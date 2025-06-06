/*
 * Photo album
 */
/obj/item/storage/photo_album
	name = "photo album"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "album"
	item_state = "briefcase"
	lefthand_file = 'icons/mob/inhands/equipment/case_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/case_righthand.dmi'
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1
	var/persistence_id

/obj/item/storage/photo_album/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(list(/obj/item/photo))
	atom_storage.max_total_storage = 42
	atom_storage.max_slots = 21
	LAZYADD(SSpersistence.photo_albums, src)

/obj/item/storage/photo_album/Destroy()
	LAZYREMOVE(SSpersistence.photo_albums, src)
	return ..()

/obj/item/storage/photo_album/proc/get_picture_id_list()
	var/list/L = list()
	for(var/i in contents)
		if(istype(i, /obj/item/photo))
			L += i
	if(!L.len)
		return
	. = list()
	for(var/i in L)
		var/obj/item/photo/P = i
		if(!istype(P.picture))
			continue
		. |= P.picture.id

//Manual loading, DO NOT USE FOR HARDCODED/MAPPED IN ALBUMS. This is for if an album needs to be loaded mid-round from an ID.
/obj/item/storage/photo_album/proc/persistence_load()
	var/list/data = SSpersistence.GetPhotoAlbums()
	if(data[persistence_id])
		populate_from_id_list(data[persistence_id])

/obj/item/storage/photo_album/proc/populate_from_id_list(list/ids)
	var/list/current_ids = get_picture_id_list()
	for(var/i in ids)
		if(i in current_ids)
			continue
		var/obj/item/photo/P = load_photo_from_disk(i)
		if(istype(P))
			if(!atom_storage?.attempt_insert(P, override = TRUE))
				qdel(P)

/obj/item/storage/photo_album/HoS
	persistence_id = "HoS"

/obj/item/storage/photo_album/RD
	persistence_id = "RD"

/obj/item/storage/photo_album/HoP
	persistence_id = "HoP"

/obj/item/storage/photo_album/Captain
	persistence_id = JOB_NAME_CAPTAIN

/obj/item/storage/photo_album/CMO
	persistence_id = "CMO"

/obj/item/storage/photo_album/QM
	persistence_id = "QM"

/obj/item/storage/photo_album/CE
	persistence_id = "CE"
