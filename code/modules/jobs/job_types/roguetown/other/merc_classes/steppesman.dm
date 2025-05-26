/datum/advclass/mercenary/steppesman
	name = "Steppesman"
	tutorial = "A mercenary from hailing from the wild frontier steppes. There are three things you value most; saigas, freedom, and coin."
	allowed_sexes = list("male", "female")
	allowed_races = list("Humen",
	"Humen",
	"Half-Elf",
	"Aasimar"
	)
	outfit = /datum/outfit/job/roguetown/mercenary/steppesman
	ismerc = TRUE

/datum/advclass/mercenary/steppesman/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	head = /obj/item/clothing/head/roguetown/papakha
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather/black
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/rogueweapon/sword/sabre
	beltl= /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights/red
	neck = /obj/item/storage/belt/rogue/pouch
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backr = /obj/item/quiver/arrows

	backpack_contents = list(/obj/item/roguekey/mercenary, /obj/item/storage/belt/rogue/pouch/coins/poor)
	
	if(H.mind)
        H.mind.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
        H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
        H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
        H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
        H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
        H.mind.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
        H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
        H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)

	H.change_stat("perception", 1)
	H.change_stat("constitution", 1)
	H.change_stat("speed", 1)
	ADD_TRAIT(H, RTRAIT_NOSEGRAB, TRAIT_GENERIC)