GLOBAL_LIST_EMPTY(uplinks)

/**
 * Uplinks
 *
 * All /obj/item(s) have a hidden_uplink var. By default it's null. Give the item one with 'new(src') (it must be in it's contents). Then add 'uses.'
 * Use whatever conditionals you want to check that the user has an uplink, and then call interact() on their uplink.
 * You might also want the uplink menu to open if active. Check if the uplink is 'active' and then interact() with it.
**/
// HIDDEN UPLINK - Can be stored in anything but the host item has to have a trigger for it.
/* How to create an uplink in 3 easy steps!

 1. All obj/item 's have a hidden_uplink var. By default it's null. Give the item one with "new(src)", it must be in it's contents. Feel free to add "uses".

 2. Code in the triggers. Use check_trigger for this, I recommend closing the item's menu with "usr << browse(null, "window=windowname") if it returns true.
 The var/value is the value that will be compared with the var/target. If they are equal it will activate the menu.

 3. If you want the menu to stay until the users locks his uplink, add an active_uplink_check(mob/user as mob) in your interact/attack_hand proc.
 Then check if it's true, if true return. This will stop the normal menu appearing and will instead show the uplink menu.
*/
/datum/component/uplink
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/flags
	var/uplink_type
	var/telecrystals
	var/telecrystals_spent = 0
	var/telecrystals_hidden = 0
	var/selected_cat
	var/owner
	var/datum/uplink_purchase_log/purchase_log
	var/gamemode
	var/job
	var/species
	/// An assoc list of references (the variable called reference on an uplink item) and its value being how many of the item
	var/list/shopping_cart
	/// A cached version of shopping_cart containing all the data for the tgui side
	var/list/cached_cart
	/// A list of 3 categories and item indexes in uplink_cats, to show as recommendedations
	var/list/lucky_numbers
	/// List of categories with items inside
	var/list/uplink_categories
	/// List of all items in total (For buying random)
	var/list/uplink_items
	var/datum/data/record/selected_record

/datum/component/uplink/Initialize(_owner, _uplink_type = UPLINK_TYPE_TRAITOR, _flags = UPLINK_FLAGS_DEFAULT, _telecrystals = TC_AMOUNT_DEFAULT)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	GLOB.uplinks += src
	owner = _owner
	if(owner)
		LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
		if(GLOB.uplink_purchase_logs_by_key[owner])
			purchase_log = GLOB.uplink_purchase_logs_by_key[owner]
		else
			purchase_log = new(owner, src)
	telecrystals = _telecrystals
	uplink_type = _uplink_type
	flags = _flags
	uplink_items = get_uplink_items(src, owner)
	if(uplink_type == UPLINK_TYPE_NUCLEAR)
		GLOB.nuclear_uplink_list += src

	RegisterSignal(parent, COMSIG_UPLINK_TRIGGER, PROC_REF(trigger))
	RegisterSignal(parent, COMSIG_UPLINK_SET_OWNER, PROC_REF(set_owner))
	RegisterSignal(parent, COMSIG_INTERACT_TARGET, PROC_REF(interact_target))
	RegisterSignal(parent, COMSIG_ACTIVATE_SELF, PROC_REF(activate_self))
	if(flags & UPLINK_BIOCHIP)
		RegisterSignal(parent, COMSIG_IMPLANT_ACTIVATED, PROC_REF(implant_activate))

/datum/component/uplink/InheritComponent(datum/component/uplink/new_uplink, i_am_original)
	if(new_uplink & UPLINK_LOCKABLE)
		flags |= UPLINK_LOCKABLE
	if(new_uplink.flags & UPLINK_ACTIVE)
		flags |= UPLINK_ACTIVE
	telecrystals += new_uplink.telecrystals
	if(purchase_log && new_uplink.purchase_log)
		purchase_log.merge_logs(new_uplink.purchase_log)

/datum/component/uplink/Destroy()
	GLOB.uplinks -= src
	if(uplink_type == UPLINK_TYPE_NUCLEAR)
		GLOB.nuclear_uplink_list -= src
	gamemode = null
	return ..()

/datum/component/uplink/proc/load_telecrystals(mob/user, obj/item/stack/telecrystal/crystals, silent = FALSE)
	if(!silent)
		to_chat(user, "<span class='notice'>You slot [crystals] into [parent] and charge its internal uplink.</span>")
	var/amount = crystals.amount
	telecrystals += amount
	crystals.use(amount)

/datum/component/uplink/proc/set_owner(new_owner, force = FALSE)
	if(owner && !force)
		stack_trace("WTF")
	owner = new_owner
	
	return TRUE

/datum/component/uplink/proc/implant_activate(cause, mob/living/user)
	trigger(user)

/datum/component/uplink/proc/set_gamemode(_gamemode)
	gamemode = _gamemode
	uplink_items = get_uplink_items(gamemode)

/datum/component/uplink/proc/interact_target(mob/living/user, obj/item/tool, list/modifiers)
	if(!(flags & UPLINK_ACTIVE))
		return
	if(istype(tool, /obj/item/stack/telecrystal))
		load_telecrystals(user, tool)
		return ITEM_INTERACT_COMPLETE

/datum/component/uplink/proc/activate_self(mob/user)
	if(flags & UPLINK_LOCKED)
		return
	flags |= UPLINK_ACTIVE
	if(user)
		ui_interact(user)
		return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/uplink/proc/generate_item_lists(mob/user)
	if(!job)
		job = user.mind.assigned_role
	if(!species)
		species = user.dna.species.name
	if(!(flags & UPLINK_INITIALIZED))
		uplink_items = get_uplink_items(src, user)

	var/list/cats = list()

	for(var/category in uplink_items)
		cats[++cats.len] = list("cat" = category, "items" = list())
		for(var/datum/uplink_item/item in uplink_items[category])
			if(uplink_type != UPLINK_TYPE_ADMIN && !(item.job?.Find(job)))
				continue
			if(length(item.species))
				if(!(item.species.Find(species)) && uplink_type != UPLINK_TYPE_ADMIN)
					continue
			cats[length(cats)]["items"] += list(list(
				"name" = sanitize(item.name),
				"desc" = sanitize(item.description()),
				"cost" = item.cost,
				"hijack_only" = item.hijack_only,
				"obj_path" = item.reference,
				"refundable" = item.refundable))
			uplink_items[item.reference] = item

	uplink_categories = cats

//If 'random' was selected
/datum/component/uplink/proc/random_pick()
	if(telecrystals <= 0)
		return

	var/list/random_items = list()

	for(var/uplink_section in uplink_items)
		for(var/datum/uplink_item/item in uplink_items[uplink_section])
			if(item.cost <= telecrystals && item.stock)
				random_items += item

	return pick(random_items)

/datum/component/uplink/proc/purchase(mob/user, datum/uplink_item/item)
	if(flags & UPLINK_JAMMED)
		to_chat(user, "<span class='warning'>[src] seems to be jammed - it cannot be used here!</span>")
		return
	if(!item.stock)
		to_chat(user, "<span class='warning'>You have redeemed this discount already.</span>")
		return
	if(telecrystals < item.cost)
		return

	var/obj/thing = item.spawn_item(get_turf(user), src, user)

	SStgui.update_uis(src)

	return thing

/datum/component/uplink/proc/mass_purchase(mob/user, datum/uplink_item/item, amount = 1)
	if(amount <= 0)
		return
	if(!item.stock)
		return

	if(item.stock > 0 && item.stock < amount)
		amount = item.stock

	. = list()
	for(var/i in 1 to amount)
		var/thing = purchase(user, item)
		if(isnull(thing))
			break
		. += thing

/datum/component/uplink/proc/refund(mob/user)
	var/obj/item/to_refund = user.get_active_hand()
	if(!to_refund) // Make sure there's actually something in the hand before even bothering to check
		to_chat(user, "<span class='warning'>[to_refund] is not refundable.</span>")
		return

	for(var/category in uplink_items)
		for(var/datum/uplink_item/item as anything in uplink_items[category])
			var/path = item.refund_path || item.item
			var/cost = item.refund_amount || item.cost

			if(ispath(to_refund.type, path) && item.refundable && to_refund.check_uplink_validity())
				var/refund_amount = cost
				if(istype(to_refund, /obj/item/guardiancreator/tech))
					var/obj/item/guardiancreator/tech/holopara = to_refund
					if(holopara.is_discounted && cost != holopara.refund_cost) // This has to be done because the normal holopara uplink datum precedes the discounted uplink datum
						continue
					refund_amount = holopara.refund_cost
				telecrystals += refund_amount
				telecrystals_spent -= refund_amount
				to_chat(user, "<span class='notice'>[to_refund] refunded.</span>")
				qdel(to_refund)
				return

	// If we are here, we didnt refund
	to_chat(user, "<span class='warning'>[to_refund] is not refundable.</span>")

// Toggles the uplink on and off. Normally this will bypass the item's normal functions and go to the uplink menu, if activated.
/datum/component/uplink/proc/toggle_active()
	flags ^= UPLINK_ACTIVE

// Directly trigger the uplink. Turn on if it isn't already.
/datum/component/uplink/proc/trigger(mob/user)
	flags |= UPLINK_ACTIVE
	ui_interact(user)

// Checks to see if the value meets the target. Like a frequency being a traitor_frequency, in order to unlock a headset.
// If true, it accesses trigger() and returns 1. If it fails, it returns false. Use this to see if you need to close the
// current item's menu.
/datum/component/uplink/proc/check_trigger(mob/user, value, target)
	. = FALSE
	if(flags & UPLINK_JAMMED)
		to_chat(user, "<span class='warning'>[src] seems to be jammed - it cannot be used here!</span>")
		return
	if(value == target)
		trigger(user)
		. = TRUE

/datum/component/uplink/proc/calculate_cart_tc()
	. = 0
	for(var/reference in shopping_cart)
		var/datum/uplink_item/item = uplink_items[reference]
		var/purchase_amt = shopping_cart[reference]
		. += item.cost * purchase_amt

/datum/component/uplink/proc/generate_tgui_cart(update = FALSE)
	if(!update)
		return cached_cart

	if(!length(shopping_cart))
		shopping_cart = null
		cached_cart = null
		return

	cached_cart = list()
	for(var/reference in shopping_cart)
		var/datum/uplink_item/item = uplink_items[reference]
		cached_cart += list(list(
			"name" = sanitize(item.name),
			"desc" = sanitize(item.description()),
			"cost" = item.cost,
			"hijack_only" = item.hijack_only,
			"obj_path" = item.reference,
			"amount" = shopping_cart[reference],
			"limit" = item.stock))

// The purchasing code.
/datum/component/uplink/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	. = TRUE

	switch(action)
		if("lock")
			flags ^= UPLINK_ACTIVE
			telecrystals += telecrystals_hidden
			telecrystals_hidden = 0
			SStgui.close_uis(src)
			for(var/reference in shopping_cart)
				if(shopping_cart[reference] == 0) // I know this isn't lazy, but this should runtime on purpose if we can't access this for some reason
					remove_from_cart(reference)

		if("refund")
			refund(ui.user)

		if("buyRandom")
			purchase(ui.user, random_pick())

		if("buyItem")
			purchase(ui.user, uplink_items[params["item"]])

		if("add_to_cart")
			var/datum/uplink_item/item = uplink_items[params["item"]]
			if(LAZYIN(shopping_cart, params["item"]))
				to_chat(ui.user, "<span class='warning'>[item.name] is already in your cart!</span>")
				return
			var/startamount = 1
			if(!item.stock)
				startamount = 0
			LAZYSET(shopping_cart, params["item"], startamount)
			generate_tgui_cart(TRUE)

		if("remove_from_cart")
			remove_from_cart(params["item"])

		if("set_cart_item_quantity")
			var/amount = text2num(params["quantity"])
			LAZYSET(shopping_cart, params["item"], max(amount, 0))
			generate_tgui_cart(TRUE)

		if("purchase_cart")
			if(flags & UPLINK_JAMMED)
				to_chat(ui.user, "<span class='warning'>[src] seems to be jammed - it cannot be used here!</span>")
				return
			if(!LAZYLEN(shopping_cart)) // sanity check
				return
			if(calculate_cart_tc() > telecrystals)
				to_chat(ui.user, "<span class='warning'>[src] buzzes, it doesn't contain enough telecrystals!</span>")
				return

			// Buying of the uplink stuff
			var/list/bought_things = list()
			for(var/reference in shopping_cart)
				var/datum/uplink_item/item = uplink_items[reference]
				bought_things += mass_purchase(item, shopping_cart[reference])

			// Check how many of them are items
			var/list/obj/item/items_for_crate = list()
			for(var/obj/item/thing in bought_things)
				// because sometimes you can buy items like crates from surpluses and stuff
				// the crates will already be on the ground, so we dont need to worry about them
				if(isitem(thing))
					items_for_crate += thing

			// If we have more than 2 of them, put them in a crate
			if(length(items_for_crate) > 2)
				var/obj/structure/closet/crate/C = new(get_turf(src))
				for(var/obj/item/item in items_for_crate)
					item.forceMove(C)
			// Otherwise, just put the items in their hands
			else if(length(items_for_crate))
				for(var/obj/item/item in items_for_crate)
					ui.user.put_in_any_hand_if_possible(item)

			empty_cart()
			SStgui.update_uis(src)

		if("empty_cart")
			empty_cart()

		if("shuffle_lucky_numbers")
			// lets see paul allen's random uplink item
			shuffle_lucky_numbers()

		if("view_record") // View Record
			var/datum/data/record/record = locateUID(params["uid_gen"])
			if(!istype(record))
				return
			selected_record = record

/datum/component/uplink/proc/shuffle_lucky_numbers()
	lucky_numbers = list()
	for(var/i in 1 to 4)
		var/cate_number = rand(1, length(uplink_categories))
		var/item_number = rand(1, length(uplink_categories[cate_number]["items"]))
		lucky_numbers += list(list("cat" = cate_number - 1, "item" = item_number - 1)) // dm lists are 1 based, js lists are 0 based, gotta -1

/datum/component/uplink/proc/remove_from_cart(item_reference) // i want to make it eventually remove all instances
	LAZYREMOVE(shopping_cart, item_reference)
	generate_tgui_cart(TRUE)

/datum/component/uplink/proc/empty_cart()
	shopping_cart = null
	generate_tgui_cart(TRUE)

/datum/component/uplink/ui_host()
	return parent

/datum/component/uplink/ui_state(mob/user)
	return GLOB.inventory_state

/datum/component/uplink/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Uplink", "hidden uplink")
		ui.open()

/datum/component/uplink/ui_data(mob/user)
	var/list/data = list()

	data["crystals"] = telecrystals

	data["cart"] = generate_tgui_cart()
	data["cart_price"] = calculate_cart_tc()
	data["lucky_numbers"] = lucky_numbers
	if(selected_record && GLOB.data_core.general.Find(selected_record))
		data["selected_record"] = list(
				"name" = html_encode(selected_record.fields["name"]),
				"sex" = html_encode(selected_record.fields["sex"]),
				"age" = html_encode(selected_record.fields["age"]),
				"species" = html_encode(selected_record.fields["species"]),
				"rank" = html_encode(selected_record.fields["rank"]),
				"nt_relation" = html_encode(selected_record.fields["nt_relation"]),
				"fingerprint" = html_encode(selected_record.fields["fingerprint"]),
				"has_photos" = (selected_record.fields["photo-south"] || selected_record.fields["photo-west"]) ? TRUE : FALSE,
				"photos" = list(selected_record.fields["photo-south"], selected_record.fields["photo-west"])
			)

	return data

/datum/component/uplink/ui_static_data(mob/user)
	var/list/data = list()

	// Actual items
	if(!uplink_categories || !uplink_items)
		generate_item_lists(user)
	if(!lucky_numbers) // Make sure these are generated AFTER the categories, otherwise shit will get messed up
		shuffle_lucky_numbers()
	data["cats"] = uplink_categories

	// Exploitable info
	var/list/exploitable = list()
	for(var/datum/data/record/record as anything in GLOB.data_core.general)
		if(isnull(selected_record))
			selected_record = record
		exploitable += list(list(
			"name" = html_encode(record.fields["name"]),
			"uid_gen" = record.UID(),
		))

	data["exploitable"] = exploitable

	return data

/obj/item/radio/uplink
	icon_state = "radio"
	var/uplink_telecrystals = TC_AMOUNT_DEFAULT
	var/uplink_type = UPLINK_TYPE_TRAITOR

/obj/item/radio/uplink/Initialize(mapload, _uplink_owner, _uplink_telecrystals)
	. = ..()
	if(!_uplink_owner && ishuman(loc))
		var/mob/living/carbon/human/human = loc
		_uplink_owner = human.key
	if(isnull(_uplink_telecrystals))
		_uplink_telecrystals = uplink_telecrystals
	AddComponent(/datum/component/uplink, _uplink_owner, uplink_type, UPLINK_FLAGS_ALWAYS_ACTIVE, _uplink_telecrystals)

/obj/item/radio/uplink/AltClick()
	return

/obj/item/radio/uplink/CtrlShiftClick()
	return

/obj/item/radio/uplink/show_examine_hotkeys()
	return list()

/obj/item/radio/uplink/nuclear
	uplink_type = UPLINK_TYPE_NUCLEAR

/obj/item/radio/uplink/sst
	uplink_type = UPLINK_TYPE_SST

/obj/item/radio/uplink/admin
	uplink_type = UPLINK_TYPE_ADMIN
	uplink_telecrystals = TC_AMOUNT_ADMIN
