extends Node3D

var walrus_jokes = [
	"Why did the walrus go to Tupperware parties? – Because he was always looking for a tight seal!",
	"What do you call a walrus in a trench coat? – An undercover blubber agent.",
	"Why don’t walruses play poker? – Too many fishy flippers.",
	"What did the walrus say to the annoying seal? – You're really krilling me!",
	"Why did the walrus bring a suitcase to the beach? – He wanted to pack his tusks.",
	"What do walruses wear to formal events? – A blubber tux.",
	"How do walruses text each other? – With blubber-tooth.",
	"What's a walrus's favorite instrument? – The tusk-a-phone.",
	"Why did the walrus join the orchestra? – He wanted to play the sea-phony.",
	"What’s a walrus’s favorite fast food? – Fish 'n glubs."
]


func _ready():
	DiscordRPC.app_id = 1402313302327038175 # Application ID
	DiscordRPC.details = walrus_jokes.pick_random()
	DiscordRPC.state = "In The Main Menu"
	DiscordRPC.large_image="walrus"
	if DiscordRPC.start_timestamp==0:
		DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
	# DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00:00 remaining"

	DiscordRPC.refresh() # Always refresh after changing the values!
