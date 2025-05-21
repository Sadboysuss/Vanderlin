/datum/special_trait/pregnant
	name = "Pregnant"
	greet_text = span_notice("The seed of life resides in me.. I must keep it safe.")
	req_text = "Be a woman"
	allowed_sexes = list(FEMALE)
	weight = 5

/datum/special_trait/pregnant/on_apply(mob/living/carbon/human/character, silent)
	character.become_pregnant(/datum/pregnancy)
