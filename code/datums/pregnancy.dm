#define PREGNANCY_STAGE_1 "stage_1"
#define PREGNANCY_STAGE_2 "stage_2"
#define PREGNANCY_STAGE_3 "stage_3"

/datum/pregnancy

	var/mob/living/carbon/parent
	/// Max health of the baby
	var/baby_max_health = 100
	/// Current health of the baby
	var/baby_current_health
	/// How many nutrients does this baby consume from the parent's body?
	var/baby_nutrient_consumption = HUNGER_FACTOR * 1.5
	/// How much thirst does the baby consume from the parent's body?
	var/baby_water_consumption = HUNGER_FACTOR * 1.5
	/// Stage of pregnancy
	var/stage = PREGNANCY_STAGE_1
	/// path of the mob that comes out at birth
	var/mob/baby_path = /mob/living/simple_animal/hostile/retaliate/trufflepig

/datum/pregnancy/New(mob/parent_mob)
	. = ..()
	baby_current_health = baby_max_health
	parent = parent_mob

/// the baby takes damage.
/datum/pregnancy/proc/take_damage(damage)
	if(!isnum(damage))
		return
	baby_current_health -= damage
	if(baby_current_health <= 0)
		baby_death()

/// womp womp
/datum/pregnancy/proc/baby_death()
	var/mob/dead_baby = new baby_path(get_turf(parent))
	dead_baby.gib()

/// the baby eats from the parent's nutrient supply
/datum/pregnancy/proc/eat()
	parent.adjust_nutrition(baby_nutrient_consumption)

/// the baby drinks from the parent's water supply
/datum/pregnancy/proc/drink()
	parent.adjust_hydration(baby_water_consumption)

/// called on the parent's life()
/datum/pregnancy/proc/on_life()
	if(prob(2))
		to_chat(parent, span_love("I feel a kick in my stomach!"))

#undef PREGNANCY_STAGE_1
#undef PREGNANCY_STAGE_2
#undef PREGNANCY_STAGE_3
