extends Node3D



func update_kills_discordRCP(kills: int) -> void:
	DiscordRPC.state="Battling The Ocra's, "+str(kills)+" killed!"
	DiscordRPC.refresh()
