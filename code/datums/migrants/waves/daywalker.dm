/datum/migrant_role/daywalker
	name = "Daywalker"
	greet_text = "Some knaves are always trying to wade upstream. You witnessed your entire village be consumed by a subservient vampiric horde - the local Priest grabbed you, and brought you to a remote Monastery; ever since then you've sworn revenge against the restless dead. The Templars showed you everything you needed to know. You walk in the day, so that the undead may only walk in the night."
	outfit = /datum/outfit/job/roguetown/daywalker
	allowed_races = list("Humen")
	grant_lit_torch = TRUE

/datum/outfit/job/roguetown/daywalker/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	neck = /obj/item/clothing/neck/roguetown/psycross/silver/astrata
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves // Would give em Fingerless, but parrying with fists sounds funny as fuck
	pants = /obj/item/clothing/under/roguetown/trou/shadowpants
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket
	shoes = /obj/item/clothing/shoes/roguetown/nobleboot
	beltl = /obj/item/flashlight/flare/torch/lantern
	mask = /obj/item/clothing/mask/rogue/goggles
	beltr = /obj/item/rogueweapon/sword/rapier
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/ring/silver
	H.virginity = TRUE

	if(H.mind)
		if(H.patron != /datum/patron/divine/astrata)
			H.set_patron(/datum/patron/divine/astrata)

		H.mind?.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE) // can you guys help me, there's so many vampires
		H.mind?.adjust_skillrank(/datum/skill/misc/climbing, 5)
		H.mind?.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE) // some motherfuckers are always trying to ice skate uphill
		H.mind?.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/combat/firearms, 2, TRUE) // Blade 3 Trinity
		H.change_stat("strength", 1)
		H.change_stat("constitution", 1)
		H.change_stat("endurance", 2)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.verbs |= /mob/living/carbon/human/proc/torture_victim //ARE YOU A FUCKING VAMPIRE?
	H.cmode_music = 'sound/music/cmode/antag/CombatThrall.ogg'

/datum/migrant_wave/daywalker
	name = "Astrata's Daywalker"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/daywalker
	weight = 1
	roles = list(
		/datum/migrant_role/daywalker = 1,
	)
	greet_text = "You give the Monarch's demense a message. You tell them it's open season on all suckheads."
