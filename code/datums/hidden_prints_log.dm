/datum/touch_logs
	var/list/touch_log = list()

/datum/touch_logs/proc/add_to_log(mob/toucher)
	if(!(toucher.ckey && !toucher.stat)) //has to be a player and conscious
		return
	var/current_time = time_stamp()
	if(!LAZYACCESS(touch_log, toucher.key))
		LAZYSET(touch_log, toucher.key, "First touched by: [toucher.real_name], Ckey: [toucher.ckey] at: \[[current_time]\]. ")
	else
		var/laststamppos = findtext(LAZYACCESS(touch_log, toucher.key), " Last: ")
		if(laststamppos)
			LAZYSET(touch_log, toucher.key, copytext(touch_log[toucher.key], 1, laststamppos))
		touch_log[toucher.key] += "Touched by: [toucher.real_name], Ckey: [toucher.ckey] at: \[[current_time]\]."	//made sure to be existing by if(!LAZYACCESS);else
