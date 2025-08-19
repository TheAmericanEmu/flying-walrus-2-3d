extends Node

func update_rpc(agent_name:String):
	DiscordRPC.state="The Noble Walrus Named,"+agent_name+" has been killed!"
	DiscordRPC.refresh()
