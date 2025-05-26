/datum/job/magician
	title = "Court Magician"
	flag = WIZARD
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = list(
		"Humen",
		"Elf",
		"Half-Elf",
		"Dwarf",
		"Aasimar"
	)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_MAGICIAN
	tutorial = "Dream interpreter, soothsayer, astrologer and valued courtier. A scholar of Noc, or a secret worshipper of Zizo. \
	Indebted to the ruler for funding yils of mystical studies in these dark times, \
	only wisdom and arcane knowledge amassed during a long life will allow a mage to unlock their full potential."
	outfit = /datum/outfit/job/magician
	whitelist_req = FALSE
	bypass_lastclass = TRUE
	give_bank_account = 120
	min_pq = 6
	cmode_music = 'sound/music/cmode/nobility/CombatCourtMagician.ogg'

/datum/outfit/job/magician
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/magician/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/wizhat/gen
	backr = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/shirt/robe/black
	cloak = /obj/item/clothing/cloak/black_cloak
	id = /obj/item/clothing/ring/gold
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltr = /obj/item/storage/keyring/mage
	backl = /obj/item/weapon/polearm/woodstaff
	shoes = /obj/item/clothing/shoes/shortboots
	backpack_contents = list(/obj/item/scrying = 1, /obj/item/reagent_containers/glass/bottle/killersice = 1)
	if(H.mind)
		if(!(H.patron == /datum/patron/divine/noc || /datum/patron/inhumen/zizo))
			H.set_patron(/datum/patron/divine/noc)

		H.mind?.adjust_skillrank(/datum/skill/misc/reading, 6, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/magic/arcane, pick(6,5), TRUE)
		H.mind?.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.mind?.adjust_skillrank(/datum/skill/craft/alchemy, 5, TRUE)
		if(H.age == AGE_OLD)
			armor = /obj/item/clothing/shirt/robe/courtmage
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_INT, 1)
			if(H.dna.species.id == "human")
				belt = /obj/item/storage/belt/leather/plaquegold
				cloak = null
				head = /obj/item/clothing/head/wizhat
				if(H.gender == FEMALE)
					armor = /obj/item/clothing/shirt/robe/courtmage
				if(H.gender == MALE)
					armor = /obj/item/clothing/shirt/robe/wizard
					H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
		ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_LEGENDARY_ALCHEMIST, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
		H.virginity = TRUE
		H.change_stat(STATKEY_STR, -2)
		H.change_stat(STATKEY_INT, 5)
		H.change_stat(STATKEY_CON, -2)
		H.change_stat(STATKEY_SPD, -2)
		H.mind.adjust_spellpoints(8)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/knock)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/learnspell)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
