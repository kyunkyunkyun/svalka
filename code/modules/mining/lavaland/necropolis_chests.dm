//The chests dropped by mob spawner tendrils. Also contains associated loot.

/obj/structure/closet/crate/necropolis
	name = "necropolis chest"
	desc = "It's watching you closely."
	icon_state = "necrocrate"
	icon_opened = "necrocrateopen"
	icon_closed = "necrocrate"
	
/obj/structure/closet/crate/necropolis/tendril
	desc = "It's watching you suspiciously."

/obj/structure/closet/crate/necropolis/tendril/New()
	..()
	// uncomment me once these items are being implemented
	/*var/loot = rand(1,25)
	switch(loot) 
		if(1)
			new /obj/item/device/shared_storage/red(src)
		if(2)
			new /obj/item/clothing/suit/space/hardsuit/cult(src)
		if(3)
			new /obj/item/device/soulstone/anybody(src)
		if(4)
			new /obj/item/weapon/katana/cursed(src)
		if(5)
			new /obj/item/clothing/glasses/godeye(src)
		if(6)
			new /obj/item/weapon/reagent_containers/glass/bottle/potion/flight(src)
		if(7)
			new /obj/item/weapon/pickaxe/diamond(src)
		if(8)
			new /obj/item/clothing/head/culthood(src)
			new /obj/item/clothing/suit/cultrobes(src)
			new /obj/item/weapon/bedsheet/cult(src)
		if(9)
			new /obj/item/organ/brain/alien(src)
		if(10)
			new /obj/item/organ/heart/cursed(src)
		if(11)
			new /obj/item/ship_in_a_bottle(src)
		if(12)
			new /obj/item/clothing/suit/space/hardsuit/ert/paranormal/beserker(src)
		if(13)
			new /obj/item/weapon/sord(src)
		if(14)
			new /obj/item/weapon/nullrod/scythe/talking(src)
		if(15)
			new /obj/item/weapon/nullrod/armblade(src)
		if(16)
			new /obj/item/weapon/guardiancreator(src)
		if(17)
			new /obj/item/borg/upgrade/modkit/aoe/turfs/andmobs(src)
		if(18)
			new /obj/item/device/warp_cube/red(src)
		if(19)
			new /obj/item/device/wisp_lantern(src)
		if(20)
			new /obj/item/device/immortality_talisman(src)
		if(21)
			new /obj/item/weapon/gun/magic/hook(src)
		if(22)
			new /obj/item/voodoo(src)
		if(23)
			new /obj/item/weapon/grenade/clusterbuster/inferno(src)
		if(24)
			new /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater/hell(src)
			new /obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor(src)
		if(25)
			new /obj/item/weapon/spellbook/oneuse/summonitem(src)*/

///Bosses
//Dragon

/obj/structure/closet/crate/necropolis/dragon
	name = "dragon chest"

/obj/structure/closet/crate/necropolis/dragon/New()
	..()
	var/loot = rand(1,4)
	switch(loot)
		if(1)
			new /obj/item/weapon/melee/ghost_sword(src)
		if(2)
			new /obj/item/weapon/lava_staff(src)
		if(3)
			new /obj/item/weapon/spellbook/oneuse/sacredflame(src)
			new /obj/item/weapon/gun/magic/wand/fireball(src)
		if(4)
			new /obj/item/weapon/dragons_blood(src)

/obj/item/weapon/melee/ghost_sword
	name = "spectral blade"
	desc = "A rusted and dulled blade. It doesn't look like it'd do much damage. It glows weakly."
	icon_state = "spectral"
	item_state = "spectral"
	flags = CONDUCT
	sharp = 1
	w_class = 4
	force = 1
	throwforce = 1
	hitsound = 'sound/effects/ghost2.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "rended")
	var/summon_cooldown = 0
	var/list/mob/dead/observer/spirits

/obj/item/weapon/melee/ghost_sword/New()
	..()
	spirits = list()
	processing_objects.Add(src)
	poi_list |= src

/obj/item/weapon/melee/ghost_sword/Destroy()
	for(var/mob/dead/observer/G in spirits)
		G.invisibility = initial(G.invisibility)
	spirits.Cut()
	processing_objects.Remove(src)
	poi_list -= src
	. = ..()

/obj/item/weapon/melee/ghost_sword/attack_self(mob/user)
	if(summon_cooldown > world.time)
		to_chat(user, "You just recently called out for aid. You don't want to annoy the spirits.")
		return
	to_chat(user, "You call out for aid, attempting to summon spirits to your side.")

	notify_ghosts("[user] is raising their [src], calling for your help!", enter_link="<a href=?src=[UID()];follow=1>(Click to help)</a>", source = user, action = NOTIFY_FOLLOW)

	summon_cooldown = world.time + 600

/obj/item/weapon/melee/ghost_sword/Topic(href, href_list)
	if(href_list["follow"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)

/obj/item/weapon/melee/ghost_sword/process()
	ghost_check()

/obj/item/weapon/melee/ghost_sword/proc/ghost_check()
	var/ghost_counter = 0
	var/turf/T = get_turf(src)
	var/list/contents = T.GetAllContents()
	var/mob/dead/observer/current_spirits = list()
	var/list/followers = list()
	
	for(var/mob/dead/observer/O in player_list)
		if(is_type_in_list(O.following, contents))
			followers += O

	for(var/thing in followers)
		if (isobserver(thing))
			var/mob/dead/observer/G = thing
			ghost_counter++
			G.invisibility = 0
			current_spirits |= G

	for(var/mob/dead/observer/G in spirits - current_spirits)
		G.invisibility = initial(G.invisibility)

	spirits = current_spirits

	return ghost_counter

/obj/item/weapon/melee/ghost_sword/attack(mob/living/target, mob/living/carbon/human/user)
	force = 0
	var/ghost_counter = ghost_check()

	force = Clamp((ghost_counter * 4), 0, 75)
	user.visible_message("<span class='danger'>[user] strikes with the force of [ghost_counter] vengeful spirits!</span>")
	..()

/obj/item/weapon/melee/ghost_sword/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance, damage, attack_type)
	var/ghost_counter = ghost_check()
	final_block_chance += Clamp((ghost_counter * 5), 0, 75)
	owner.visible_message("<span class='danger'>[owner] is protected by a ring of [ghost_counter] ghosts!</span>")
	return ..()

// Blood

/obj/item/weapon/dragons_blood
	name = "bottle of dragons blood"
	desc = "You're not actually going to drink this, are you?"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "vial"

/obj/item/weapon/dragons_blood/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return

	var/mob/living/carbon/human/H = user
	var/random = rand(1,3)

	switch(random)
		if(1)
			to_chat(user, "<span class='danger'>Your flesh begins to melt! Miraculously, you seem fine otherwise.</span>")
			H.set_species("Skeleton")
		if(2)
			to_chat(user, "<span class='danger'>You don't feel so good...</span>")
			message_admins("[key_name_admin(user)] has started transforming into a dragon via dragon's blood.")
			H.ForceContractDisease(new /datum/disease/transformation/dragon(0))
		if(3)
			to_chat(user, "<span class='danger'>You feel like you could walk straight through lava now.</span>")
			H.weather_immunities |= "lava"

	playsound(user.loc,'sound/items/drink.ogg', rand(10,50), 1)
	qdel(src)

/datum/disease/transformation/dragon
	name = "dragon transformation"
	cure_text = "nothing"
	cures = list("adminordrazine")
	agent = "dragon's blood"
	desc = "What do dragons have to do with Space Station 13?"
	stage_prob = 20
	severity = BIOHAZARD
	visibility_flags = 0
	stage1	= list("Your bones ache.")
	stage2	= list("Your skin feels scaley.")
	stage3	= list("<span class='danger'>You have an overwhelming urge to terrorize some peasants.</span>", "<span class='danger'>Your teeth feel sharper.</span>")
	stage4	= list("<span class='danger'>Your blood burns.</span>")
	stage5	= list("<span class='danger'>You're a fucking dragon. However, any previous allegiances you held still apply. It'd be incredibly rude to eat your still human friends for no reason.</span>")
	new_form = /mob/living/simple_animal/hostile/megafauna/dragon/lesser
	
//Lava Staff

/obj/item/weapon/lava_staff
	name = "staff of lava"
	desc = "The ability to fill the emergency shuttle with lava. What more could you want out of life?"
	icon_state = "staffofstorms"
	item_state = "staffofstorms"
	icon = 'icons/obj/guns/magic.dmi'
	slot_flags = SLOT_BACK
	item_state = "staffofstorms"
	w_class = 4
	force = 25
	damtype = BURN
	hitsound = 'sound/weapons/sear.ogg'
	var/turf_type = /turf/unsimulated/floor/lava // /turf/simulated/floor/plating/lava/smooth once Lavaland turfs are added
	var/transform_string = "lava"
	var/reset_turf_type = /turf/simulated/floor/plating/airless/asteroid // /turf/simulated/floor/plating/asteroid/basalt once Lavaland turfs are added
	var/reset_string = "basalt"
	var/create_cooldown = 100
	var/create_delay = 30
	var/reset_cooldown = 50
	var/timer = 0
	var/banned_turfs

/obj/item/weapon/lava_staff/New()
	. = ..()
	banned_turfs = typecacheof(list(/turf/space/transit, /turf/unsimulated))

/obj/item/weapon/lava_staff/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	if(timer > world.time)
		return

	if(is_type_in_typecache(target, banned_turfs))
		return

	if(target in view(user.client.view, get_turf(user)))

		var/turf/simulated/T = get_turf(target)
		if(!istype(T))
			return
		if(!istype(T, turf_type))
			var/obj/effect/overlay/temp/lavastaff/L = PoolOrNew(/obj/effect/overlay/temp/lavastaff, T)
			L.alpha = 0
			animate(L, alpha = 255, time = create_delay)
			user.visible_message("<span class='danger'>[user] points [src] at [T]!</span>")
			timer = world.time + create_delay + 1
			if(do_after(user, create_delay, target = T))
				user.visible_message("<span class='danger'>[user] turns \the [T] into [transform_string]!</span>")
				message_admins("[key_name_admin(user)] fired the lava staff at [get_area(target)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>).")
				log_game("[key_name(user)] fired the lava staff at [get_area(target)] ([T.x], [T.y], [T.z]).")
				T.ChangeTurf(turf_type)
				timer = world.time + create_cooldown
				qdel(L)
			else
				timer = world.time
				qdel(L)
				return
		else
			user.visible_message("<span class='danger'>[user] turns \the [T] into [reset_string]!</span>")
			T.ChangeTurf(reset_turf_type)
			timer = world.time + reset_cooldown
		playsound(T,'sound/magic/Fireball.ogg', 200, 1)

/obj/effect/overlay/temp/lavastaff
	icon_state = "lavastaff_warn"
	duration = 50