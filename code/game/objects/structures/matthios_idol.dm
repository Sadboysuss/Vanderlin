

/obj/structure/fluff/statue/evil
	name = "idol"
	desc = "A statue built to the robber-god, Matthios, who stole the gift of fire from the underworld. It is said that he grants the wishes of those pagan bandits (free folk) who feed him money."
	icon_state = "evilidol"
	icon = 'icons/roguetown/misc/structure.dmi'

	var/static/list/tier_1_loot_list = list(
		"Scalemail" = /obj/item/clothing/armor/medium/scale,
		"Haubergeon" = /obj/item/clothing/armor/chainmail/iron,
		"Longbow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long,
		"Longsword" = /obj/item/weapon/sword/long,
		"Steel Mace" = /obj/item/weapon/mace/steel,
		"Chain Chausses" = /obj/item/clothing/pants/chainlegs,
		"Gorget" = /obj/item/clothing/neck/gorget,
		"Hardened Leather Coat" = /obj/item/clothing/armor/leather/advanced,
		"Hide Armor" = /obj/item/clothing/armor/leather/hide,
		"Horned Helmet" = /obj/item/clothing/head/helmet/horned,
		"Horned Helmet" = /obj/item/clothing/head/helmet/horned,
		"Horned Helmet" = /obj/item/clothing/head/helmet/horned,
		"Horned Helmet" = /obj/item/clothing/head/helmet/horned,
		"Horned Helmet" = /obj/item/clothing/head/helmet/horned,
	)

	var/static/list/tier_2_loot_list = list(
		"Plate armor" = /obj/item/clothing/armor/plate/full,
		"Haubergeon" = /obj/item/clothing/armor/chainmail,
		"Longbow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long,
		"Longsword" = /obj/item/weapon/sword/long,
		"Steel Mace" = /obj/item/weapon/mace/steel,
	)



	/// Assoc list with key as a typepath and the value as a modifier to how much money it gives.
	var/static/list/loot_list = list(
		/obj/item/coin = 1,
		/obj/item/gem = 0.7,
		/obj/item/reagent_containers/glass = 0.5,
		/obj/item/clothing/head/crown = 0.6,
		/obj/item/statue = 0.7,
		/obj/item/ingot = 0.6,
	)

/obj/structure/fluff/statue/evil/attackby(obj/item/W, mob/user, params)
	if(user.mind)
		var/datum/antagonist/bandit/B = user.mind.has_antag_datum(/datum/antagonist/bandit)
		if(B)
			if(istype(W, /obj/item/coin) || istype(W, /obj/item/gem) || istype(W, /obj/item/reagent_containers/glass/cup/silver) || istype(W, /obj/item/reagent_containers/glass/cup/golden) || istype(W, /obj/item/reagent_containers/glass/carafe) || istype(W, /obj/item/clothing/ring) || istype(W, /obj/item/clothing/head/crown/circlet) || istype(W, /obj/item/statue))
				if(B.tri_amt >= 10)
					to_chat(user, "<span class='warning'>The mouth doesn't open.</span>")
					return
				if(!istype(W, /obj/item/coin))
					B.contrib += (W.get_real_price() / 2) //sell jewerly and other fineries, though at a lesser price compared to fencing them first
					GLOB.vanderlin_round_stats[STATS_SHRINE_VALUE] += (W.get_real_price() / 2)
				else
					B.contrib += W.get_real_price()
					GLOB.vanderlin_round_stats[STATS_SHRINE_VALUE] += W.get_real_price()
				if(B.contrib >= 100)
					B.tri_amt++
					user.mind.adjust_triumphs(1)
					B.contrib -= 100
					var/obj/item/I
					switch(B.tri_amt)
						if(1)
							I = new /obj/item/reagent_containers/glass/bottle/healthpot(user.loc)
						if(2)
							if(HAS_TRAIT(user, TRAIT_MEDIUMARMOR))
								I = new /obj/item/clothing/armor/medium/scale(user.loc)
							else
								I = new /obj/item/clothing/armor/chainmail/iron(user.loc)
						if(4)
							I = new (user.loc)
						if(6)
							if(user.get_skill_level(/datum/skill/combat/polearms) > 2)
								I = new /obj/item/weapon/polearm/spear/billhook(user.loc)
							else if(user.get_skill_level(/datum/skill/combat/bows) > 2)
								I = new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long(user.loc)
							else if(user.get_skill_level(/datum/skill/combat/swords) > 2)
								I = new /obj/item/weapon/sword/long(user.loc)
							else
								I = new /obj/item/weapon/mace/steel(user.loc)
						if(8)
							I = new /obj/item/clothing/pants/chainlegs(user.loc)
					if(I)
						I.sellprice = 0
					playsound(loc,'sound/items/matidol2.ogg', 50, TRUE)
				else
					playsound(loc,'sound/items/matidol1.ogg', 50, TRUE)
				playsound(loc,'sound/misc/eat.ogg', rand(30,60), TRUE)
				qdel(W)
				return
	..()
