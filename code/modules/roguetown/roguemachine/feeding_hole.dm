/obj/structure/roguemachine/feedinghole
	name = "FEEDING HOLE"
	desc = "Sends materials to the stockpile and coin to the treasury without giving anything in return."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "feedinghole"
	density = FALSE
	pixel_y = 32
	var/static/feed_me_phrases = list("FEED ME.", "I MUST CONSUME", "GIVE ME WHAT YOU HAVE.", "I NEED IT.", "GIVE IT TO ME.")

/obj/structure/roguemachine/feedinghole/attackby(obj/item/P, mob/user, params)
	attemptstockpile(P, user)

/obj/structure/roguemachine/feedinghole/attackby(obj/item/P, mob/user, params)

/obj/structure/roguemachine/feedinghole/attack_hand(mob/user)
	say(pick(feed_me_phrases))
	. = ..()


/obj/structure/roguemachine/feedinghole/proc/attemptstockpile(obj/item/I, mob/H, message = TRUE, sound = TRUE)
	for(var/datum/roguestock/R in SStreasury.stockpile_datums)
		if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			if(B.stacktype == R.item_type)
				R.held_items += B.amount
				if(message == TRUE)
					stock_announce("[B.amount] units of [R.name] has been stockpiled.")
				qdel(B)
				if(sound == TRUE)
					playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			continue
		else if(istype(I,R.item_type))
			if(!R.check_item(I))
				continue
			if(!R.transport_item)
				R.held_items += 1 //stacked logs need to check for multiple
				qdel(I)
				if(message == TRUE)
					stock_announce("[R.name] has been stockpiled.")
				if(sound == TRUE)
					playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)

	if(istype(I, /obj/item/roguecoin))
		var/money_worth = I.get_real_price()
		SStreasury.give_money_treasury(money_worth, "feeding hole")
		if(message)
			say("Deposited [money_worth] mammon worth of coin.")
		if(sound)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		qdel(I)
	else
		var/area/A = GLOB.areas_by_type[R.transport_item]
		if(!A && message == TRUE)
			say("Couldn't find where to send the material.")
			return
		I.submitted_to_stockpile = TRUE
		var/list/turfs = list()
		for(var/turf/T in A)
			turfs += T
		var/turf/T = pick(turfs)
		I.forceMove(T)
		if(sound == TRUE)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			return
