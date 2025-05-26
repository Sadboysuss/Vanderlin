/datum/anvil_recipe
	var/name
	var/list/additional_items = list()
	var/material_quality = 0 // Accumulated per added ingot
	var/num_of_materials = 1 // Materials used
	var/skill_quality = 0 // Accumulated per hit on calculation, will decide final result
	var/appro_skill = /datum/skill/craft/blacksmithing
	var/req_bar
	var/created_item
	var/craftdiff = 0
	var/needed_item
	var/needed_item_text
	var/quality_mod = 0
	var/progress
	var/i_type
	var/recipe_name

	var/datum/parent

/datum/anvil_recipe/New(datum/P, ...)
	parent = P
	. = ..()

/datum/anvil_recipe/proc/advance(mob/user, breakthrough = FALSE)
	if(progress == 100)
		to_chat(user, "<span class='info'>It's ready.</span>")
		user.visible_message("<span class='warning'>[user] strikes the bar!</span>")
		return FALSE
	if(needed_item)
		to_chat(user, "<span class='info'>Now it's time to add a [needed_item_text].</span>")
		user.visible_message("<span class='warning'>[user] strikes the bar!</span>")
		return FALSE
	var/moveup = 1
	var/proab = 3
	var/skill_level
	if(user.mind)
		skill_level = user.mind.get_skill_level(appro_skill)
		moveup += round((skill_level * 6) * (breakthrough == 1 ? 1.5 : 1))
		moveup -= 3 * craftdiff
		if(!user.mind.get_skill_level(appro_skill))
			proab = 23
	if(prob(proab))
		moveup = 0
	progress = min(progress + moveup, 100)
	if(progress == 100 && additional_items.len)
		needed_item = pick(additional_items)
		var/obj/item/I = new needed_item()
		needed_item_text = I.name
		qdel(I)
		additional_items -= needed_item
		progress = 0
	if(!moveup)
		if(prob(round(proab/2)))
			user.visible_message("<span class='warning'>[user] ruins the bar!</span>")
			if(parent)
				var/obj/item/P = parent
				qdel(P)
			return FALSE
		else
			user.visible_message("<span class='warning'>[user] fumbles the bar!</span>")
			return FALSE
	else
		if(user.mind && isliving(user))
			skill_quality += (rand(skill_level*8, skill_level*17)*moveup)
			var/mob/living/L = user
			var/boon = user.mind.get_learning_boon(appro_skill)
			var/amt2raise = L.STAINT/2
			if(amt2raise > 0)
				user.mind.adjust_experience(appro_skill, amt2raise * boon, FALSE)
		if(breakthrough)
			user.visible_message("<span class='warning'>[user] strikes the bar!</span>")
		else		
			user.visible_message("<span class='info'>[user] strikes the bar!</span>")
		return TRUE

/datum/anvil_recipe/proc/item_added(mob/user)
	needed_item = null
	user.visible_message("<span class='info'>[user] adds [needed_item_text]</span>")
	needed_item_text = null

/datum/anvil_recipe/proc/handle_creation(obj/item/I)
	material_quality = floor(material_quality/num_of_materials)-2
	skill_quality = floor((skill_quality/num_of_materials)/1500)+material_quality
	var/modifier
	switch(skill_quality)
		if(BLACKSMITH_LEVEL_MIN to BLACKSMITH_LEVEL_SPOIL)
			I.name = "ruined [I.name]"
			modifier = 0.3
		if(BLACKSMITH_LEVEL_AWFUL)
			I.name = "awful [I.name]"
			modifier = 0.5
		if(BLACKSMITH_LEVEL_CRUDE)
			I.name = "crude [I.name]"
			modifier = 0.8
		if(BLACKSMITH_LEVEL_ROUGH)
			I.name = "rough [I.name]"
			modifier = 0.9
		if(BLACKSMITH_LEVEL_COMPETENT)
			modifier = 1
		if(BLACKSMITH_LEVEL_FINE)
			I.name = "fine [I.name]"
			modifier = 1.1
		if(BLACKSMITH_LEVEL_FLAWLESS)
			I.name = "flawless [I.name]"
			modifier = 1.2
		if(BLACKSMITH_LEVEL_LEGENDARY to BLACKSMITH_LEVEL_MAX)
			I.name = "masterwork [I.name]"
			modifier = 1.3
		
	if(!modifier)
		return
	I.max_integrity  *= modifier
	I.obj_integrity *= modifier
	I.sellprice *= modifier
	if(istype(I, /obj/item/rogueweapon))
		var/obj/item/rogueweapon/W = I
		W.force *= modifier
		W.throwforce *= modifier
		W.blade_int *= modifier
		W.max_blade_int *= modifier
		W.armor_penetration *= modifier
		W.wdefense *= modifier
	if(istype(I, /obj/item/clothing))
		var/obj/item/clothing/C = I
		C.damage_deflection *= modifier
		C.integrity_failure /= modifier
		C.armor = C.armor.multiplymodifyAllRatings(modifier)
		C.equip_delay_self *= modifier

