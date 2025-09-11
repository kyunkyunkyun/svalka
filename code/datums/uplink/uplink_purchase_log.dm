GLOBAL_LIST(uplink_purchase_logs_by_key) //assoc key = /datum/uplink_purchase_log

/datum/uplink_purchase_log
	var/owner
	var/list/purchase_log //assoc path-of-item = /datum/uplink_purchase_entry
	var/total_spent = 0

/datum/uplink_purchase_log/New(_owner, datum/component/uplink/_parent)
	owner = _owner
	LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
	if(owner)
		if(GLOB.uplink_purchase_logs_by_key[owner])
			stack_trace("WARNING: DUPLICATE PURCHASE LOGS DETECTED. [_owner] [_parent] [_parent.type]")
			merge_logs(GLOB.uplink_purchase_logs_by_key[owner])
		GLOB.uplink_purchase_logs_by_key[owner] = src
	purchase_log = list()

/datum/uplink_purchase_log/Destroy()
	purchase_log = null
	if(GLOB.uplink_purchase_logs_by_key[owner] == src)
		GLOB.uplink_purchase_logs_by_key -= owner
	return ..()

/datum/uplink_purchase_log/proc/merge_logs(datum/uplink_purchase_log/other)
	if(!istype(other))
		return
	. = owner == other.owner
	if(!.)
		return
	for(var/hash in other.purchase_log)
		if(!purchase_log[hash])
			purchase_log[hash] = other.purchase_log[hash]
		else
			var/datum/uplink_purchase_entry/entry = purchase_log[hash]
			var/datum/uplink_purchase_entry/other_entry = other.purchase_log[hash]
			entry.amount_purchased += other_entry.amount_purchased
	qdel(other)

/datum/uplink_purchase_log/proc/generate_render(show_key = TRUE)
	for(var/hash in purchase_log)
		var/datum/uplink_purchase_entry/entry = purchase_log[hash]
		. += "<span class='tooltip_container'>\[[entry.icon_b64][show_key?"([owner])":""]<span class='tooltip_hover'><b>[entry.name]</b> \
			<br>[entry.spent_cost ? "[entry.spent_cost] TC" : "[entry.base_cost] TC<br>(Surplus)"]<br>[entry.desc]</span>[(entry.amount_purchased > 1) ? "x[entry.amount_purchased]" : ""]\]</span>"

/datum/uplink_purchase_log/proc/log_purchase(atom/A, datum/uplink_item/uplink_item, spent_cost)
	var/datum/uplink_purchase_entry/entry
	var/hash = hash_purchase(uplink_item, spent_cost)
	if(purchase_log[hash])
		entry = purchase_log[hash]
	else
		entry = new
		purchase_log[hash] = entry
		entry.path = A.type
		entry.icon_b64 = "[icon2base64(A)]"
		entry.desc = uplink_item.desc
		entry.name = uplink_item.name
		entry.base_cost = initial(uplink_item.cost)
		entry.spent_cost = spent_cost

	entry.amount_purchased++
	total_spent += spent_cost

/datum/uplink_purchase_log/proc/hash_purchase(datum/uplink_item/uplink_item, spent_cost)
	return "[uplink_item.type]|[uplink_item.name]|[uplink_item.cost]|[spent_cost]"

/datum/uplink_purchase_entry
	var/amount_purchased
	var/path
	var/icon_b64
	var/desc
	var/base_cost
	var/spent_cost
	var/name
