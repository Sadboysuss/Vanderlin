/obj/item/organ/eyes
	name = "eyes"
	icon_state = "eyeball"
	desc = ""
	zone = BODY_ZONE_PRECISE_R_EYE
	slot = ORGAN_SLOT_EYES
	gender = PLURAL

	visible_organ = TRUE

	organ_dna_type = /datum/organ_dna/eyes
	accessory_type = /datum/sprite_accessory/eyes/humanoid

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY
	maxHealth = 0.5 * STANDARD_ORGAN_THRESHOLD		//half the normal health max since we go blind at 30, a permanent blindness at 50 therefore makes sense unless medicine is administered
	high_threshold = 0.3 * STANDARD_ORGAN_THRESHOLD	//threshold at 30
	low_threshold = 0.2 * STANDARD_ORGAN_THRESHOLD	//threshold at 20

	low_threshold_passed = "<span class='info'>Distant objects become somewhat less tangible.</span>"
	high_threshold_passed = "<span class='info'>Everything starts to look a lot less clear.</span>"
	now_failing = "<span class='warning'>Darkness envelopes you, as my eyes go blind!</span>"
	now_fixed = "<span class='info'>Color and shapes are once again perceivable.</span>"
	high_threshold_cleared = "<span class='info'>My vision functions passably once more.</span>"
	low_threshold_cleared = "<span class='info'>My vision is cleared of any ailment.</span>"

	var/sight_flags = 0
	var/see_in_dark = 8
	var/tint = 0
	var/eye_icon_state = "eyes"
	var/flash_protect = FLASH_PROTECTION_NONE
	var/see_invisible = SEE_INVISIBLE_LIVING
	var/lighting_alpha
	var/no_glasses
	var/damaged	= FALSE	//damaged indicates that our eyes are undergoing some level of negative effect

	var/old_eye_color = "fff" //cache owners original eye color before inserting new eyes
	var/eye_color = ""//set to a hex code to override a mob's eye color
	var/heterochromia = FALSE
	var/second_color = "#FFFFFF"

	/// Do these eyes have blinking animations
	var/blink_animation = TRUE
	/// Should our blinking be synchronized or can separate eyes have (slightly) separate blinking times
	var/synchronized_blinking = TRUE
	// A pair of abstract eyelid objects (yes, really) used to animate blinking
	var/obj/effect/abstract/eyelid_effect/eyelids

/obj/item/organ/eyes/Initialize(mapload)
	. = ..()
	if (blink_animation)
		eyelids = new(src, "[eye_icon_state]")

/obj/item/organ/eyes/Destroy()
	QDEL_NULL(eyelids)
	return ..()

/obj/item/organ/eyes/update_overlays()
	. = ..()
	if(initial(eye_color) && (icon_state == "eyeball"))
		var/mutable_appearance/iris_overlay = mutable_appearance(src.icon, "eyeball-iris")
		iris_overlay.color = "#" + eye_color
		. += iris_overlay

/obj/item/organ/eyes/update_accessory_colors()
	var/list/colors_list = list()
	colors_list += eye_color
	if(heterochromia)
		colors_list += second_color
	else
		colors_list += eye_color
	accessory_colors = color_list_to_string(colors_list)

/obj/item/organ/eyes/imprint_organ_dna(datum/organ_dna/organ_dna)
	. = ..()
	var/datum/organ_dna/eyes/eyes_dna = organ_dna
	eyes_dna.eye_color = eye_color
	eyes_dna.heterochromia = heterochromia
	eyes_dna.second_color = second_color

/obj/item/organ/eyes/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE, initialising)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/HMN = owner
		if(eye_color)
			HMN.regenerate_icons()
	for(var/datum/wound/facial/eyes/eye_wound as anything in M.get_wounds())
		qdel(eye_wound)
	M.update_tint()
	owner.update_sight()
	if(M.has_dna() && ishuman(M))
		M.dna.species.handle_body(M) //updates eye icon

#define BASE_BLINKING_DELAY 5 SECONDS
#define RAND_BLINKING_DELAY 1 SECONDS
#define BLINK_DURATION 0.15 SECONDS
#define BLINK_LOOPS 5

/// Modifies eye overlays to also act as eyelids, both for blinking and for when you're knocked out cold
/obj/item/organ/eyes/proc/setup_eyelids(mutable_appearance/eyes, mob/living/carbon/human/parent)
	var/obj/item/bodypart/head/my_head = parent.get_bodypart(BODY_ZONE_HEAD)

	var/list/base_color = rgb2num(my_head.color, COLORSPACE_HSL)
	base_color[2] *= 0.85
	base_color[3] *= 0.85
	var/eyelid_color = rgb(base_color[1], base_color[2], base_color[3], (length(base_color) >= 4 ? base_color[4] : null), COLORSPACE_HSL)
	// If we're knocked out, just color the eyes
	if (HAS_TRAIT(parent, TRAIT_KNOCKEDOUT))
		eye_right.color = eyelid_color
		eye_left.color = eyelid_color
		return

	if (!blink_animation)
		return

	eyelids.color = eyelid_color
	eyelids.render_target = "*[REF(parent)]_eyelids"
	parent.vis_contents += eyelids
	animate_eyelids(parent)
	var/mutable_appearance/eyelids_overlay = mutable_appearance(layer = -BODY_LAYER)
	eyelids_overlay.render_source = "*[REF(parent)]_eyelids"
	return eyelids_overlay

/// Animates one eyelid at a time, thanks BYOND and thanks animation chains
/obj/item/organ/eyes/proc/animate_eyelid(obj/effect/abstract/eyelid_effect/eyelids, mob/living/carbon/human/parent, sync_blinking = TRUE, list/anim_times = null)
	. = list()
	var/prevent_loops = FALSE
	animate(eyelid, alpha = 0, time = 0, loop = (prevent_loops ? 0 : -1))

	var/wait_time = rand(BASE_BLINKING_DELAY - RAND_BLINKING_DELAY, BASE_BLINKING_DELAY + RAND_BLINKING_DELAY)
	if (anim_times)
		if (sync_blinking)
			wait_time = anim_times[1]
			anim_times.Cut(1, 2)
		else
			wait_time = rand(max(BASE_BLINKING_DELAY - RAND_BLINKING_DELAY, anim_times[1] - RAND_BLINKING_DELAY), anim_times[1])

	animate(time = wait_time)
	. += wait_time

	var/cycles = (prevent_loops ? 1 : BLINK_LOOPS)
	for (var/i in 1 to cycles)
		if (anim_times)
			if (sync_blinking)
				wait_time = anim_times[1]
				anim_times.Cut(1, 2)
			else
				wait_time = rand(max(BASE_BLINKING_DELAY - RAND_BLINKING_DELAY, anim_times[1] - RAND_BLINKING_DELAY), anim_times[1])
		else
			wait_time = rand(BASE_BLINKING_DELAY - RAND_BLINKING_DELAY, BASE_BLINKING_DELAY + RAND_BLINKING_DELAY)
		. += wait_time
		if (anim_times && !sync_blinking)
			// Make sure that we're somewhat in sync with the other eye
			animate(time = anim_times[1] - wait_time)
			anim_times.Cut(1, 2)
		animate(alpha = 255, time = 0)
		animate(time = BLINK_DURATION)
		if (i != cycles)
			animate(alpha = 0, time = 0)
			animate(time = wait_time)

/obj/item/organ/eyes/proc/blink(duration = BLINK_DURATION, restart_animation = TRUE)
	var/left_delayed = rand(50)
	// Storing blink delay so mistimed blinks of lizards don't get cut short
	var/blink_delay = synchronized_blinking ? rand(0, RAND_BLINKING_DELAY) : 0
	animate(eyelid_left, alpha = 0, time = 0)
	if (!synchronized_blinking && left_delayed)
		animate(time = blink_delay)
	animate(alpha = 255, time = 0)
	animate(time = duration)
	animate(alpha = 0, time = 0)
	animate(eyelid_right, alpha = 0, time = 0)
	if (!synchronized_blinking && !left_delayed)
		animate(time = blink_delay)
	animate(alpha = 255, time = 0)
	animate(time = duration)
	animate(alpha = 0, time = 0)
	if (restart_animation)
		addtimer(CALLBACK(src, PROC_REF(animate_eyelids), owner), blink_delay + duration)

/obj/item/organ/eyes/proc/animate_eyelids(mob/living/carbon/human/parent)
	var/sync_blinking = synchronized_blinking
	// Randomize order for unsynched animations
	if (sync_blinking || prob(50))
		var/list/anim_times = animate_eyelid(eyelid_left, parent, sync_blinking)
		animate_eyelid(eyelid_right, parent, sync_blinking, anim_times)
	else
		var/list/anim_times = animate_eyelid(eyelid_right, parent, sync_blinking)
		animate_eyelid(eyelid_left, parent, sync_blinking, anim_times)

/obj/effect/abstract/eyelid_effect
	name = "eyelid"
	icon = 'icons/mob/human_parts.dmi'
	layer = -BODY_LAYER
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE | VIS_INHERIT_ID

/obj/effect/abstract/eyelid_effect/Initialize(mapload, new_state)
	. = ..()
	icon_state = new_state

#undef BASE_BLINKING_DELAY
#undef RAND_BLINKING_DELAY
#undef BLINK_DURATION
#undef BLINK_LOOPS

/obj/item/organ/eyes/Remove(mob/living/carbon/M, special = 0)
	. = ..()
	if(ishuman(M) && eye_color)
		var/mob/living/carbon/human/HMN = M
		HMN.regenerate_icons()
	M.cure_blind(EYE_DAMAGE)
	M.cure_nearsighted(EYE_DAMAGE)
	M.set_blindness(0)
	M.set_blurriness(0)
	M.update_sight()

/obj/item/organ/eyes/on_life()
	..()
	var/mob/living/carbon/C = owner
	//since we can repair fully damaged eyes, check if healing has occurred
	if((organ_flags & ORGAN_FAILING) && (damage < maxHealth))
		organ_flags &= ~ORGAN_FAILING
		C.cure_blind(EYE_DAMAGE)
	//various degrees of "oh fuck my eyes", from "point a laser at my eye" to "staring at the Sun" intensities
	if(damage > 20)
		damaged = TRUE
		if((organ_flags & ORGAN_FAILING))
			C.become_blind(EYE_DAMAGE)
		else if(damage > 30)
			C.overlay_fullscreen("eye_damage", /atom/movable/screen/fullscreen/impaired, 2)
		else
			C.overlay_fullscreen("eye_damage", /atom/movable/screen/fullscreen/impaired, 1)
	//called once since we don't want to keep clearing the screen of eye damage for people who are below 20 damage
	else if(damaged)
		damaged = FALSE
		C.clear_fullscreen("eye_damage")
	return


/obj/item/organ/eyes/night_vision
	name = "shadow eyes"
	desc = ""
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	actions_types = list(/datum/action/item_action/organ_action/use)
	var/night_vision = TRUE

/obj/item/organ/eyes/night_vision/ui_action_click()
	sight_flags = initial(sight_flags)
	switch(lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
			sight_flags &= ~SEE_BLACKNESS
	owner.update_sight()

/obj/item/organ/eyes/night_vision/alien
	name = "alien eyes"
	desc = ""
	sight_flags = SEE_MOBS

/obj/item/organ/eyes/night_vision/zombie
	name = "undead eyes"
	desc = ""
	eye_color = "#FFFFFF"

/obj/item/organ/eyes/night_vision/werewolf
	name = "moonlight eyes"
	desc = ""

/obj/item/organ/eyes/night_vision/nightmare
	name = "burning red eyes"
	desc = ""
	// icon_state = "burning_eyes"
	eye_color = BLOODCULT_EYE

/obj/item/organ/eyes/night_vision/mushroom
	name = "fung-eye"
	desc = ""

/obj/item/organ/eyes/elf
	name = "elf eyes"
	desc = ""
	see_in_dark = 4
	lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT

/obj/item/organ/eyes/elf/less
	name = "elf eyes"
	desc = ""
	see_in_dark = 3
	lighting_alpha = LIGHTING_PLANE_ALPHA_LESSER_NV_TRAIT

/obj/item/organ/eyes/no_render
	accessory_type = null

/proc/set_eye_color(mob/living/carbon/mob, color_one, color_two)
	var/obj/item/organ/eyes/eyes = mob.getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		return
	if(color_one)
		eyes.eye_color = color_one
	if(color_two)
		eyes.second_color = color_two
	eyes.update_accessory_colors()
	if(eyes.owner)
		eyes.owner.update_body_parts(TRUE)
