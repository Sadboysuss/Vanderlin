/mob/proc/add_stress(event)
	return TRUE

/mob/proc/remove_stress(event)
	return TRUE

/mob/proc/update_stress()
	return TRUE


/mob/proc/get_stress_amount()
	return 0

/mob/proc/adjust_stress(amt)
	return TRUE

/mob/proc/has_stress(event)
	return TRUE

/mob/living/carbon
	var/stress = 1
	var/list/stress_timers = list()
	var/oldstress = 1
	var/stressbuffer = -1
	var/list/negative_stressors = list()
	var/list/positive_stressors = list()

/mob/living/carbon/adjust_stress(amt)
	stressbuffer = stressbuffer + amt
	stress = stress + stressbuffer
	stressbuffer = 0
	if(stress > STRESS_MAX)
		stressbuffer = STRESS_MAX - stress
		stress = STRESS_MAX
	if(stress < 0)
		stressbuffer = stress
		stress = 0

/mob/living/carbon/update_stress()
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		stress = 0
		if(hud_used)
			if(hud_used.stressies)
				hud_used.stressies.update_icon(stress)
		return
	for(var/datum/stressevent/D in negative_stressors)
		if(D.timer)
			if(world.time > (D.time_added + D.timer))
				remove_stress(D.type)
	for(var/datum/stressevent/D in positive_stressors)
		if(D.timer)
			if(world.time > (D.time_added + D.timer))
				remove_stress(D.type)

	if(stress != oldstress)
		if(stress > oldstress)
			to_chat(src, "<span class='red'>I gain stress.</span>")
		else
			to_chat(src, "<span class='green'>I gain peace.</span>")
		switch(stress)
			if(STRESS_VGOOD)
				apply_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_VGOOD+1 to STRESS_BAD-1)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_BAD to STRESS_VBAD-1)
				apply_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_VBAD to STRESS_INSANE-1)
				apply_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_INSANE to STRESS_MAX)
				apply_status_effect(/datum/status_effect/stress/stressinsane)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvbad)

		if(hud_used)
			if(hud_used.stressies)
				hud_used.stressies.update_icon()
	oldstress = stress


/mob/living/carbon/get_stress_amount()
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		return 0
	return stress

/mob/living/carbon/has_stress(event)
	var/amount
	for(var/datum/stressevent/D in negative_stressors)
		if(D.type == event)
			amount++
	for(var/datum/stressevent/D in positive_stressors)
		if(D.type == event)
			amount++
	return amount

/mob/living/carbon/add_stress(event)
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		return FALSE
	var/datum/stressevent/N = new event()
	if(!N.can_apply(src))
		return FALSE
	var/found = FALSE
	if(N.stressadd > 0)
		for(var/datum/stressevent/D in negative_stressors)
			if(D.type == event)
				found = TRUE
				if(D.stacks >= D.max_stacks)
					continue
				D.time_added = world.time
				var/pre_stack = D.get_stress()
				D.stacks++
				var/post_stack = D.get_stress()
				if(N.stressadd > D.stressadd)
					D.stressadd = N.stressadd
				adjust_stress(post_stack-pre_stack)
	else
		for(var/datum/stressevent/D in positive_stressors)
			if(D.type == event)
				found = TRUE
				if(D.stacks >= D.max_stacks)
					continue
				D.time_added = world.time
				var/pre_stack = D.get_stress()
				D.stacks++
				var/post_stack = D.get_stress()
				if(N.stressadd < D.stressadd)
					D.stressadd = N.stressadd
				adjust_stress(post_stack-pre_stack)
	if(found)
		return TRUE
	N.time_added = world.time
	N.stacks = 1
	if(N.stressadd > 0)
		negative_stressors += N
	else
		positive_stressors += N
	adjust_stress(N.get_stress())
	return TRUE

// Pass typepaths into this proc
/mob/living/carbon/remove_stress(event)
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		return FALSE
	var/list/eventL
	if(islist(event))
		eventL = event
	for(var/datum/stressevent/D in negative_stressors)
		if(eventL)
			if(D.type in eventL)
				adjust_stress(-1*D.get_stress())
				negative_stressors -= D
				qdel(D)
		else
			if(D.type == event)
				adjust_stress(-1*D.get_stress())
				negative_stressors -= D
				qdel(D)
	for(var/datum/stressevent/D in positive_stressors)
		if(eventL)
			if(D.type in eventL)
				adjust_stress(-1*D.get_stress())
				positive_stressors -= D
				qdel(D)
		else
			if(D.type == event)
				adjust_stress(-1*D.get_stress())
				positive_stressors -= D
				qdel(D)
	return TRUE

#ifdef TESTSERVER
/client/verb/add_stress()
	set category = "DEBUGTEST"
	set name = "stressBad"
	if(mob)
		mob.add_stress(/datum/stressevent/test)

/client/verb/remove_stress()
	set category = "DEBUGTEST"
	set name = "stressGood"
	if(mob)
		mob.add_stress(/datum/stressevent/testr)

/client/verb/filter1()
	set category = "DEBUGTEST"
	set name = "TestFilter1"
	if(mob)
		mob.remove_client_colour(/datum/client_colour/test1)
		mob.remove_client_colour(/datum/client_colour/test2)
		mob.remove_client_colour(/datum/client_colour/test3)
		mob.add_client_colour(/datum/client_colour/test1)

/client/verb/filter2()
	set category = "DEBUGTEST"
	set name = "TestFilter2"
	if(mob)
		mob.remove_client_colour(/datum/client_colour/test1)
		mob.remove_client_colour(/datum/client_colour/test2)
		mob.remove_client_colour(/datum/client_colour/test3)
		mob.add_client_colour(/datum/client_colour/test2)

/client/verb/filter3()
	set category = "DEBUGTEST"
	set name = "TestFilter3"
	if(mob)
		mob.remove_client_colour(/datum/client_colour/test1)
		mob.remove_client_colour(/datum/client_colour/test2)
		mob.remove_client_colour(/datum/client_colour/test3)
		mob.add_client_colour(/datum/client_colour/test3)

/client/verb/do_undesaturate()
	set category = "DEBUGTEST"
	set name = "TestFilterOff"
	if(mob)
		mob.remove_client_colour(/datum/client_colour/test1)
		mob.remove_client_colour(/datum/client_colour/test2)
		mob.remove_client_colour(/datum/client_colour/test3)

/client/verb/do_flash()
	set category = "DEBUGTEST"
	set name = "doflash"
	if(mob)
		var/turf/T = get_turf(mob)
		if(T)
			T.flash_lighting_fx(30)
#endif
