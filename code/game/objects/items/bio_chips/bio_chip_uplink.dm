/obj/item/bio_chip/uplink
	name = "uplink bio-chip"
	desc = "Summon things."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	origin_tech = "materials=4;magnets=4;programming=4;biotech=4;syndicate=5;bluespace=5"
	implant_data = /datum/implant_fluff/uplink
	implant_state = "implant-syndicate"
	var/uplink_type = UPLINK_TYPE_TRAITOR

/obj/item/bio_chip/uplink/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/uplink, _uplink_type = uplink_type, _telecrystals = TC_AMOUNT_BIO_CHIP, _flags = UPLINK_FLAGS_BIOCHIP)

/obj/item/bio_chip/uplink/nuclear
	uplink_type = UPLINK_TYPE_NUCLEAR

/obj/item/bio_chip/uplink/sit
	uplink_type = UPLINK_TYPE_SIT

/obj/item/bio_chip/uplink/admin
	uplink_type = UPLINK_TYPE_ADMIN

/obj/item/bio_chip/uplink/implant(mob/source, mob/user, force)
	var/obj/item/bio_chip/uplink/existing_biochip = locate(/obj/item/bio_chip/uplink) in source
	if(existing_biochip && existing_biochip != src)
		var/datum/component/uplink/new_uplink = GetComponent(/datum/component/uplink)
		var/datum/component/uplink/existing_uplink = existing_biochip.GetComponent(/datum/component/uplink)
		existing_uplink.InheritComponent(new_uplink, TRUE)
		qdel(src)
		return TRUE

	. = ..()
	if(!.)
		return
	SEND_SIGNAL(src, COMSIG_UPLINK_SET_OWNER, source.key)

/obj/item/bio_chip_implanter/uplink
	name = "bio-chip implanter (uplink)"
	implant_type = /obj/item/bio_chip/uplink

/obj/item/bio_chip_case/uplink
	name = "bio-chip case - 'Syndicate Uplink'"
	desc = "A glass case containing an uplink bio-chip."
	implant_type = /obj/item/bio_chip/uplink

/obj/item/bio_chip_implanter/nuclear
	name = "bio-chip implanter (Nuclear Agent Uplink)"
	implant_type = /obj/item/bio_chip/uplink/nuclear

/obj/item/bio_chip_case/nuclear
	name = "bio-chip case - 'Nuclear Agent Uplink'"
	implant_type = /obj/item/bio_chip/uplink/nuclear
