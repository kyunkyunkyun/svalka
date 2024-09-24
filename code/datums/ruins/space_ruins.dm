//The bigger ones lag like hell if there is more than one on a z-level, so cost 2 for them
/datum/map_template/ruin/space
	prefix = "_maps/map_files/RandomRuins/SpaceRuins/"
	cost = 1 // Varies from 0 to 10. Make sure you don't make it higher than 10 and use 0 only with the always_place
	ci_exclude = /datum/map_template/ruin/space

/datum/map_template/ruin/space/zoo
	id = "zoo"
	suffix = "abandonedzoo.dmm"
	name = "Biological Storage Facility"
	description = "In case society crumbles, we will be able to restore our \
		zoos to working order with the breeding stock kept in these 100% \
		secure and unbreachable storage facilities. At no point has anything \
		escaped. That's our story, and we're sticking to it."
	cost = 3 // temp gun, double oxy emergency tank, stimpack

/datum/map_template/ruin/space/asteroid1
	id = "asteroid1"
	suffix = "asteroid1.dmm"
	name = "Asteroid 1"
	description = "I-spy with my little eye, something beginning with R."

/datum/map_template/ruin/space/asteroid2
	id = "asteroid2"
	suffix = "asteroid2.dmm"
	name = "Asteroid 2"
	description = "Oh my god, a giant rock!"

/datum/map_template/ruin/space/asteroid3
	id = "asteroid3"
	suffix = "asteroid3.dmm"
	name = "Asteroid 3"
	description = "This asteroid floating in space has no official \
		designation, because the scientist that discovered it deemed it \
		'super dull'."

/datum/map_template/ruin/space/asteroid4
	id = "asteroid4"
	suffix = "asteroid4.dmm"
	name = "Asteroid 4"
	description = "Nanotrasen Escape Pods have a 100%* success rate, and a \
		99%* customer satisfaction rate. *Please note that these statistics, \
		are taken from pods that have successfully docked with a recovery \
		vessel."

/datum/map_template/ruin/space/asteroid5
	id = "asteroid5"
	suffix = "asteroid5.dmm"
	name = "Asteroid 5"
	description = "Oh my god, another giant rock!"
	cost = 2 // pretty huge, hivelord spawner

/datum/map_template/ruin/space/deep_storage
	id = "deep-storage"
	suffix = "deepstorage.dmm"
	name = "Survivalist Bunker"
	description = "Assume the best, prepare for the worst. Generally, you \
		should do so by digging a three man heavily fortified bunker into \
		a giant unused asteroid. Then make it self sufficient, mask any \
		evidence of construction, hook it covertly into the \
		telecommunications network and hope for the best."
	cost = 10 // dvorak+mo19 experience + mini boss. Big one
	allow_duplicates = FALSE // this shouldn't be spawning more than once anymore

/datum/map_template/ruin/space/derelict1
	id = "derelict1"
	suffix = "derelict1.dmm"
	name = "Derelict 1"
	description = "Nothing to see here citizen, move along, certainly no \
		xeno outbreaks on this piece of station debris. That purple stuff? \
		It's uh... station nectar. It's a top secret research installation."

/datum/map_template/ruin/space/derelict2
	id = "derelict2"
	suffix = "derelict2.dmm"
	name = "Dinner for Two"
	description = "Oh this is the night\n\
		It's a beautiful night\n\
		And we call it bella notte"

/datum/map_template/ruin/space/derelict3
	id = "derelict3"
	suffix = "derelict3.dmm"
	name = "Derelict 3"
	description = "These hulks were once part of a larger structure, where \
		the three great \[REDACTED\] were forged."
	cost = 3 // A space dragon!
	allow_duplicates = FALSE

/datum/map_template/ruin/space/derelict4
	id = "derelict4"
	suffix = "derelict4.dmm"
	name = "Derelict 4"
	description = "Centcom ferries have never crashed, will never crash, \
		there is no current investigation into a crashed ferry, and we \
		will not let Internal Affairs trample over high security information \
		in the name of this baseless witchhunt."

/datum/map_template/ruin/space/derelict5
	id = "derelict5"
	suffix = "derelict5.dmm"
	name = "Derelict 5"
	description = "The plan is, we put a whole bunch of crates full of \
		treasure in this disused warehouse, launch it into space, and then \
		ignore it. Forever."
	cost = 2 // toolbox, hivelords

/datum/map_template/ruin/space/listeningpost
	id = "listeningpost"
	suffix = "listeningpost.dmm"
	name = "Syndie Listening Post"
	description = "What happens to Nuclear Operatives that fail in their mission? \
		Certainly not assignment to a backwater listening post..."
	cost = 3 // toolbox, 150kJ cells, lots of healing, syndie corpse, telecomms, red soap

/datum/map_template/ruin/space/empty_shell
	id = "empty-shell"
	suffix = "emptyshell.dmm"
	name = "Empty Shell"
	description = "Cosy, rural property available for young professional \
		couple. Only twelve parsecs from the nearest hyperspace lane!"

/datum/map_template/ruin/space/intact_empty_ship
	id = "intact-empty-ship"
	suffix = "intactemptyship.dmm"
	name = "Authorship"
	description = "Just somewhere quiet, where I can focus on my work with \
		no interruptions."
	cost = 2 // tarot card, medibot

/datum/map_template/ruin/space/mech_transport
	id = "mech-transport"
	suffix = "mechtransport.dmm"
	name = "Cybersun Exosuit Factory Ship"
	description = "A crashed mobile mech factory under security lockdown."
	cost = 2 // mechcore, pirates, couple of crates
	allow_duplicates = FALSE

/datum/map_template/ruin/space/onehalf
	id = "onehalf"
	suffix = "onehalf.dmm"
	name = "DK Excavator 453"
	description = "Based on the trace elements we've detected on the \
		gutted asteroids, we suspect that a mining ship using a restricted \
		engine is somewhere in the area. We'd like to request a patrol vessel \
		to investigate."
	cost = 3 // first aid kits, secret docs, mining mod

/datum/map_template/ruin/space/spacebar
	id = "spacebar"
	suffix = "spacebar.dmm"
	name = "The Rampant Golem and Yellow Hound"
	description = "No questions asked. No shoes/foot protection, no service. \
		No tabs. No violence in the inside areas. That's it. Welcome to the \
		Rampant Golem and Yellow Hound. Can I take your order?"
	always_place = TRUE
	cost = 0
	allow_duplicates = FALSE //it spawn ship docking, no more than one to avoid duplication in console.

/datum/map_template/ruin/space/turreted_outpost
	id = "turreted-outpost"
	suffix = "turretedoutpost.dmm"
	name = "Unnamed Turreted Outpost"
	description = "We'd ask them to stop blaring that ruskiepop music, but \
		none of us are brave enough to go near those death turrets they have."
	cost = 2 // military belt, camerabug, 30kJ cell

/datum/map_template/ruin/space/way_home
	id = "way-home"
	suffix = "way_home.dmm"
	name = "Salvation"
	description = "In the darkest times, we will find our way home."

/datum/map_template/ruin/space/oldstation
	id = "oldstation"
	suffix = "oldstation.dmm"
	name = "Ancient Space Station"
	description = "The crew of a space station awaken one hundred years after a crisis. Awaking to a derelict space station on the verge of collapse, and a hostile force of invading \
	hivebots. Can the surviving crew overcome the odds and survive and rebuild, or will the cold embrace of the stars become their new home?"
	always_place = TRUE
	cost = 0
	allow_duplicates = FALSE

/datum/map_template/ruin/space/wizardcrash
	id = "wizardcrash"
	suffix = "wizardcrash.dmm"
	name = "Crashed Wizard Shuttle"
	description = "A shuttle of the Wizard Federation, sent out to crush some wandless scum. Unfortunately, the pilot suffered a magic-related accident and the shuttle crashed into a nearby asteroid."
	cost = 4 // blank tarot, random artefact

/datum/map_template/ruin/space/abandonedtele
	id = "abandonedtele"
	suffix = "abandonedtele.dmm"
	name = "Abandoned Teleporter"
	description = "An old teleporter, seemingly part of what used to be a larger satellite."
	cost = 2 // shortcut

/datum/map_template/ruin/space/blowntcommsat
	id = "blowntcommsat"
	suffix = "blowntcommsat.dmm"
	name = "Blown-out Telecommunications Satellite"
	description = "The remains of an old telecommunications satellite once utilised by Nanotrasen. It lays derelict, with quite a few pieces missing."
	cost = 7 // bloodmod, teleporter console, toolbox, 50u syringe, nvg. This is a chonky boy
	allow_duplicates = FALSE // Absolutely huge, also has its own APC and the area isnt set to allow many

/datum/map_template/ruin/space/malftcommsat
	id = "malftcommsat"
	suffix = "telecomns_returns.dmm"
	name = "D.V.O.R.A.K'S Telecommunications Satellite"
	description = "Seems the telecomunication satellite that went dark 4 years ago finally re-appeared on scanners? Strange signals are coming from it."
	cost = 10 // Huge. Large. In charge
	allow_duplicates = FALSE // One sadistic malfunctioning AI is enough. Also unique apcs.

/datum/map_template/ruin/space/clownmime
	id = "clownmime"
	suffix = "clownmime.dmm"
	name = "Clown & Mime Mineral Deposits"
	description = "A crash site of two opposing factions, both trying to complete mining trips for their own valuable minerals. While all the crew have long perished, the minerals are likely intact."
	cost = 2 // Honk!

/datum/map_template/ruin/space/dj
	id = "dj"
	suffix = "dj.dmm"
	name = "Soviet DJ Station"
	description = "An old soviet era listening station, long since defunct and lifeless, however the equipment is likely still in working condition."

/datum/map_template/ruin/space/druglab
	id = "druglab"
	suffix = "druglab.dmm"
	name = "Drug Lab"
	description = "An old abandoned \"Chemistry\" site, which has a strong aura of amphetamines around it."
	cost = 2 // chem dispenser, pirate

/datum/map_template/ruin/space/syndicatedruglab
	id = "syndicatedruglab"
	suffix = "syndicatedruglab.dmm"
	name = "Suspicious Station"
	description = "A syndicate drug laboratory hidden on an asteroid. It is strangely well-protected."
	allow_duplicates = FALSE
	cost = 3 // soap, syndie corpse, chem dispenser, hydroponics, void puppies

/datum/map_template/ruin/space/syndiedepot
	id = "syndiedepot"
	suffix = "syndiedepot.dmm"
	name = "Suspicious Supply Depot"
	description = "A syndicate supply depot, heavily stocked, but heavily guarded with an assortment of shields, sentry bots, armed operatives and more."
	always_place = TRUE // This is on the always spawn list because of the shielding chance
	cost = 0 // Force spawned so shouldnt have a cost
	allow_duplicates = FALSE // One of these is enough

/datum/map_template/ruin/space/ussp_tele
	id = "ussp_tele"
	suffix = "ussp_tele.dmm"
	name = "USSP Teleporter"
	description = "An old, almost fully destroyed teleporter, seemingly part of what used to be a much larger structure."
	cost = 2 // shortcut

/datum/map_template/ruin/space/ussp
	id = "ussp"
	suffix = "ussp.dmm"
	name = "USSP"
	description = "A decript station of seemingly Soviet origin. The last contact had with this station was a distress signal, and the rest was dark."
	allow_duplicates = FALSE // One of these has enough loot

/datum/map_template/ruin/space/whiteship
	id = "whiteship"
	suffix = "whiteship.dmm"
	name = "NEV Limulus"
	description = "A small expeditionary ship for use in local space exploration and salvaging."
	always_place = TRUE // Its designed to make exploring other space ruins more accessible
	cost = 0 // Force spawned so shouldnt have a cost
	allow_duplicates = FALSE // I dont even want to think about what happens if you have 2 shuttles with the same ID. Likely scary stuff.

/datum/map_template/ruin/space/golem_destination
	id = "golemtarget"
	suffix = "golemtarget.dmm"
	name = "Golem Shuttle Destination"
	description = "Just a handful of rocks floating in space. Guaranteed space destination for the Golem shuttle in case other destinations don't spawn."
	always_place = TRUE
	cost = 0
	allow_duplicates = FALSE

/datum/map_template/ruin/space/syndicate_space_base
	name = "Syndicate Space Base"
	id = "syndie-space-base"
	description = "A secret base researching illegal bioweapons, it is closely guarded by an elite team of syndicate agents."
	suffix = "syndie_space_base.dmm"
	always_place = TRUE
	cost = 0
	allow_duplicates = FALSE

/datum/map_template/ruin/space/syndiecakesfactory
	id = "Syndiecakes Factory"
	suffix = "syndiecakesfactory.dmm"
	name = "Syndicakes Factory"
	description = "Syndicate used to get funds selling corgi cakes produced here. Was it hit by meteors or by a Nanotrasen comando?"
	cost = 5 // bloodmod, toolbox, syndie cakes and corpses
	allow_duplicates = FALSE

/datum/map_template/ruin/space/debris1
	id = "debris1"
	suffix = "debris1.dmm"
	name = "Debris field 1"
	description = "A bunch of metal chunks, wires and space waste"

/datum/map_template/ruin/space/debris2
	id = "debris2"
	suffix = "debris2.dmm"
	name = "Debris field 2"
	description = "A bunch of metal chunks, wires and space waste that used to be some kind of secure storage facility"

/datum/map_template/ruin/space/debris3
	id = "debris3"
	suffix = "debris3.dmm"
	name = "Debris field 3"
	description = "A bunch of metal chunks, wires and space waste. It used to be an arcade."

/datum/map_template/ruin/space/meatpackers
	id = "meatpackers"
	suffix = "meatpackers.dmm"
	name = "Meat Packers"
	description = "An old transport ship, possibly with a dubious past. It smells faintly of meat."
	cost = 4 // Toolbox, syndie eva, pirates, chem dispenser, big
	allow_duplicates = FALSE

/datum/map_template/ruin/space/mo19
	id = "mo19"
	suffix = "moonoutpost19.dmm"
	name = "Moon Outpost 19"
	description = "A now-defunct outpost, with the last received signal being that of distress."
	cost = 10 // A113, void/mech/anomalycore, research notes, huge
	allow_duplicates = FALSE

/datum/map_template/ruin/space/voyager
	id = "voyager"
	suffix = "voyager.dmm"
	name = "Voyager"
	description = "A relic of old times, you don't know what it hide inside."
	allow_duplicates = FALSE

/datum/map_template/ruin/space/wreckedcargoship
	id = "wreckedcargoship"
	suffix = "wreckedcargoship.dmm"
	name = "Wrecked Cargoship"
	description = "A cargo shuttle in a wrecked condition. There are many unknown horrors in space and looks like its last crew has faced one of them."
	cost = 2 // With the loot it contains it shouldn't be found frequently
	allow_duplicates = FALSE

/datum/map_template/ruin/space/abandoned_engi_sat
	id = "abandoned_engi_sat"
	suffix = "abandoned_engi_sat.dmm"
	name = "Abandoned NT Engineering Satellite"
	description = "A derelict operating base for NT engineering crew."
	allow_duplicates = FALSE

/datum/map_template/ruin/space/rocky_motel
	id = "rocky_motel"
	suffix = "rocky_motel.dmm"
	name = "Rocky Motel"
	description = "A cozy little home nestled in an asteroid, perfect for one or two people!"
	cost = 2
	allow_duplicates = FALSE

/datum/map_template/ruin/space/casino
	id = "casino"
	suffix = "casino.dmm"
	name = "Dorian Casino"
	description = "A swanky space casino."
	cost = 3 // shortcut, pirates, medium-size
	allow_duplicates = FALSE

/datum/map_template/ruin/space/abandoned_security_shuttle
	id = "abandoned_sec_shuttle"
	suffix = "abandoned_sec_shuttle.dmm"
	name = "Abandoned Security Shuttle"
	description = "A security shuttle that has been floating in space."
	cost = 2 // medbeam, enforcer, first aid kit. But extra tiny
	allow_duplicates = FALSE
