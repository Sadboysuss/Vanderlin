/**
 * Matthios loot datum
 * spend favor to get cool items
 * Vars:
 ** tier - tier at which it is unlocked
 ** name - name shown in the list
 ** cost - how much favor this takes
 ** item_path - which item it spawns
*/

/datum/matthios_loot
	/// What tier is this unlocked at
	var/tier
	/// name displayed in the list
	var/name = "bad code"
	/// how much favor does this cost
	var/cost
	/// path of the item it creates
	var/item_path


/* Tier one! */

/datum/matthios_loot/tier_1
	tier = 1

