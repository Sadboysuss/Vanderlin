// Mobs shouldn't consider their own ambush.
// This should be it's own system. Please.

#define AMBUSH_CHANCE 5

/mob/living/proc/ambushable()
	if(MOBTIMER_FINISHED(src, MT_AMBUSHLAST, 5 MINUTES))
		return FALSE
	if(stat) //what?
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	return ambushable

/mob/living/proc/consider_ambush()
	if(!prob(AMBUSH_CHANCE))
		return

	if(!MOBTIMER_FINISHED(src, MT_AMBUSHCHECK, 15 SECONDS))
		return
	MOBTIMER_SET(src, MT_AMBUSHCHECK)

	if(!ambushable())
		return
	var/area/AR = get_area(src)
	if(!length(AR.ambush_mobs))
		return
	var/turf/T = get_turf(src)
	if(!T)
		return
	if(!(T.type in AR.ambush_types))
		return
	var/campfires = 0
	for(var/obj/machinery/light/fueled/RF in view(5, src))
		if(RF.on)
			campfires++
	if(campfires > 0)
		return
	var/victims = 1
	var/list/victimsa = list()
	for(var/mob/living/V in view(5, src))
		if(V != src)
			if(V.ambushable())
				victims++
				victimsa += V
			if(victims > 3)
				return
	var/list/possible_targets = list()
	for(var/obj/structure/flora/tree/RT in view(5, src))
		if(istype(RT,/obj/structure/table/wood/treestump))
			continue
		if(isturf(RT.loc))
			testing("foundtree")
			possible_targets += RT.loc
//	for(var/obj/structure/flora/grass/bush/RB in range(7, src))
//		if(can_see(src, RB))
//			possible_targets += RB
	for(var/obj/structure/flora/shroom_tree/RX in view(5, src))
		if(isturf(RX.loc))
			testing("foundshroom")
			possible_targets += RX.loc
	for(var/obj/structure/flora/newtree/RS in view(5, src))
		if(!RS.density)
			continue
		if(isturf(RS.loc))
			testing("foundshroom")
			possible_targets += RS.loc
	if(length(possible_targets))
		MOBTIMER_SET(src, MT_AMBUSHLAST)
		for(var/mob/living/V in victimsa)
			MOBTIMER_SET(V, MT_AMBUSHLAST)
		var/spawnedtype = pickweight(AR.ambush_mobs)
		var/mustype = 1
		for(var/i in 1 to CLAMP(victims*1,2,3))
			var/spawnloc = pick(possible_targets)
			if(spawnloc)
				var/mob/spawnedmob = new spawnedtype(spawnloc)
				if(istype(spawnedmob, /mob/living/simple_animal/hostile))
					var/mob/living/simple_animal/hostile/M = spawnedmob
					M.attack_same = FALSE
					M.del_on_deaggro = 44 SECONDS
					M.GiveTarget(src)
				if(istype(spawnedmob, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = spawnedmob
					H.del_on_deaggro = 44 SECONDS
					H.last_aggro_loss = world.time
					H.retaliate(src)
					mustype = 2
		if(mustype == 1)
			playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
		else
			playsound_local(src, pick('sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
		shake_camera(src, 2, 2)
		if(iscarbon(src))
			var/mob/living/carbon/C = src
			if(C.stress >= 30 && (prob(50)))
				C.heart_attack()
