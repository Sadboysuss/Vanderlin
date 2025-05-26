/datum/supply_pack/tools
	group = "Tools"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/tools/rope
	name = "Rope"
	cost = 7
	contains = /obj/item/rope

/datum/supply_pack/tools/chain
	name = "Chain"
	cost = 11
	contains = /obj/item/rope/chain

/datum/supply_pack/tools/lockpicks
	name = "Lockpicks"
	cost = 20
	contains = /obj/item/lockpickring/mundane

/datum/supply_pack/tools/needle
	name = "Sewing Needle"
	cost = 10
	contains = /obj/item/needle

/datum/supply_pack/tools/sack
	name = "Sack"
	cost = 4
	contains = /obj/item/storage/sack

/datum/supply_pack/tools/sleepingbag
	name = "Sleeping Bag"
	cost = 12
	contains = /obj/item/sleepingbag

/datum/supply_pack/tools/scroll
	name = "Parchment Scroll"
	cost = 2
	contains = /obj/item/paper/scroll

/datum/supply_pack/tools/parchment
	name = "Parchment"
	cost = 1
	contains = /obj/item/paper

/datum/supply_pack/tools/flint
	name = "Flint"
	cost = 20
	contains = /obj/item/flint

/datum/supply_pack/tools/dyebin
	name = "Fine dyes"
	cost = 200
	contains = /obj/structure/dye_bin


/datum/supply_pack/tools/candles
	name = "Candles"
	cost = 10
	contains = list(/obj/item/candle/yellow,
	/obj/item/candle/yellow,
	/obj/item/candle/yellow)

/datum/supply_pack/tools/lamptern
	name = "Iron Lamptern"
	cost = 12
	contains = /obj/item/flashlight/flare/torch/lantern

/datum/supply_pack/tools/pick
	name = "Pickaxe"
	cost = 15
	contains = /obj/item/weapon/pick

/datum/supply_pack/tools/tongs
	name = "Tongs"
	cost = 20
	contains = /obj/item/weapon/tongs

/datum/supply_pack/tools/hammer
	name = "Hammer"
	cost = 20
	contains = /obj/item/weapon/hammer/iron

/datum/supply_pack/tools/shovel
	name = "Shovel"
	cost = 15
	contains = /obj/item/weapon/shovel

/datum/supply_pack/tools/Sickle
	name = "Sickle"
	cost = 15
	contains = /obj/item/weapon/sickle

/datum/supply_pack/tools/pitchfork
	name = "Pitchfork"
	cost = 15
	contains = /obj/item/weapon/pitchfork

/datum/supply_pack/tools/hoe
	name = "Hoe"
	cost = 15
	contains = /obj/item/weapon/hoe

/datum/supply_pack/tools/bottle
	name = "Glass Bottle"
	cost = 3
	contains = /obj/item/reagent_containers/glass/bottle

/datum/supply_pack/tools/alch_bottle
	name = "Alchemy Bottle"
	cost = 1
	contains = /obj/item/reagent_containers/glass/alchemical

/datum/supply_pack/tools/alch_bottles
	name = "Bulk Alchemy Bottles" //Buy 8 now get 1 free!
	cost = 8
	contains = list(/obj/item/reagent_containers/glass/alchemical,/obj/item/reagent_containers/glass/alchemical,/obj/item/reagent_containers/glass/alchemical,
	/obj/item/reagent_containers/glass/alchemical,/obj/item/reagent_containers/glass/alchemical,/obj/item/reagent_containers/glass/alchemical,
	/obj/item/reagent_containers/glass/alchemical,/obj/item/reagent_containers/glass/alchemical,/obj/item/reagent_containers/glass/alchemical)

/datum/supply_pack/tools/bucket
	name = "Bucket"
	cost = 6
	contains = /obj/item/reagent_containers/glass/bucket/wooden

/datum/supply_pack/tools/fryingpan
	name = "Frying Pan"
	cost = 12
	contains = /obj/item/cooking/pan

/datum/supply_pack/tools/pot
	name = "Cooking Pot"
	cost = 15
	contains = /obj/item/reagent_containers/glass/bucket/pot

/datum/supply_pack/food/cutlery
	name = "Set of Cutlery"
	cost = 10
	contains = list(/obj/item/kitchen/platter/clay,
	/obj/item/reagent_containers/glass/bowl/clay,
	/obj/item/reagent_containers/glass/cup,
	/obj/item/kitchen/fork,
	/obj/item/kitchen/spoon)

/datum/supply_pack/tools/wpipe
	name = "Westman Pipe"
	cost = 10
	contains = /obj/item/clothing/face/cigarette/pipe/westman

/datum/supply_pack/tools/fishingrod
	name = "Fishing Rod"
	cost = 12
	contains = /obj/item/fishingrod

/datum/supply_pack/tools/bait
	name = "Fishing Grub"
	cost = 6
	contains = /obj/item/fishing/bait/deluxe

/datum/supply_pack/tools/fishingline
	name = "Premium Fishing line"
	cost = 25
	contains = /obj/item/fishing/reel/deluxe

/datum/supply_pack/tools/fishinghook
	name = "Premium Fishing hook"
	cost = 25
	contains = /obj/item/fishing/hook/deluxe

/datum/supply_pack/tools/prarml
	name = "Prosthetic Left Wooden Arm"
	cost = 15
	contains = /obj/item/bodypart/l_arm/prosthetic/wood

/datum/supply_pack/tools/prarmr
	name = "Prosthetic Right Wooden Arm"
	cost = 15
	contains = /obj/item/bodypart/r_arm/prosthetic/wood

/datum/supply_pack/tools/prlegl
	name = "Pegleg Left Leg"
	cost = 15
	contains = /obj/item/bodypart/l_leg/prosthetic/wood

/datum/supply_pack/tools/prlegr
	name = "Pegleg Right Leg"
	cost = 15
	contains = /obj/item/bodypart/r_leg/prosthetic/wood

/datum/supply_pack/tools/surgerybag
	name = "Set of Surgical Tools"
	cost = 100
	contains = /obj/item/storage/backpack/satchel/surgbag

/datum/supply_pack/tools/glassware_set
	name = "Set of Glassware Cups"
	cost = 34 // These glasses are really expensive
	contains = list(/obj/item/reagent_containers/glass/cup/glassware, /obj/item/reagent_containers/glass/cup/glassware, /obj/item/reagent_containers/glass/cup/glassware)

/datum/supply_pack/tools/glassware_set
	name = "Set of Glassware Wine Glasses"
	cost = 34 // These glasses are really expensive
	contains = list(/obj/item/reagent_containers/glass/cup/glassware/wineglass, /obj/item/reagent_containers/glass/cup/glassware/wineglass, /obj/item/reagent_containers/glass/cup/glassware/wineglass)

/datum/supply_pack/tools/glassware_set
	name = "Set of Glassware Shot Glasses"
	cost = 28 // These glasses are really expensive
	contains = list(/obj/item/reagent_containers/glass/cup/glassware/shotglass, /obj/item/reagent_containers/glass/cup/glassware/shotglass, /obj/item/reagent_containers/glass/cup/glassware/shotglass,)
