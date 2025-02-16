/datum/event/gravity
	id = "gravity"
	name = "Gravity Failure"
	description = "The gravity generator will be turned off for a while"

	mtth = 2 HOURS
	difficulty = 40

	blacklisted_maps = (/datum/map/polar)

/datum/event/gravity/New()
	. = ..()

	add_think_ctx("announce", CALLBACK(src, .proc/announce), 0)

/datum/event/gravity/get_mtth()
	. = ..()
	. -= (SSevents.triggers.roles_count["Engineer"] * (11 MINUTES))
	. = max(1 HOUR, .)

/datum/event/gravity/on_fire()
	var/obj/machinery/gravity_generator/main/GG = GLOB.station_gravity_generator
	if(!GG)
		log_debug("The gravity generator was not found while trying to start an event.")
		return

	GG.set_state(FALSE)
	set_next_think_ctx("announce", world.time + (rand(30, 60) SECONDS))

/datum/event/gravity/proc/announce()
	var/list/affecting_z = GLOB.using_map.get_levels_with_trait(ZTRAIT_STATION)
	command_announcement.Announce(
		"Feedback surge detected in mass-distributions systems. Engineers are strongly advised to deal with the problem.",
		"Gravity Failure",
		new_sound = 'sound/AI/gravitystart.ogg',
		zlevels = affecting_z
	)
