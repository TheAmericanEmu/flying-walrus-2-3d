extends Node3D

var do_online = false

func get_game_server():
	var save_game_path="user://user_data//config.json"
	var save_file = FileAccess.open(save_game_path,FileAccess.READ)
	var data = JSON.parse_string(save_file.get_as_text())
	return data["web_server_address"]


func load_scorebroad():
	var scoreboard
	var url = get_game_server()
	var tree:Tree = $Leaderboard/Panel/Tree
	var http_request:HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	var tree_root = tree.create_item()

	http_request.request_completed.connect(func(result, response_code, headers, body:PackedByteArray):
		scoreboard=JSON.parse_string(body.get_string_from_utf8())
		for log:Dictionary in scoreboard:
			var temp = tree.create_item(tree_root)
			temp.set_text(0,log["player_name"])
			temp.set_text(1,str(log["score"]))
		)
	http_request.request(url+"/get_scores",["Content-Type: application/json"],HTTPClient.METHOD_GET)



func _ready() -> void:
	randomize()
	if(do_online == false):
		var save_game_path="user://user_data//save_data.json"
		var file = FileAccess.open(save_game_path,FileAccess.READ)
		var data:Dictionary = JSON.parse_string(file.get_as_text())
		$"Stat Card/Panel/Name".text+=" A Player"
		$"Stat Card/Panel/Rank".text += " "+data["rank"]
		$"Stat Card/Panel/UWID".text += " "+str(randi())
		var total_score:Tree=$"Stat Card/Panel/LifeScores"
		var root = total_score.create_item()
		for key in data["total_stats"].keys():
			var temp = total_score.create_item(root)
			temp.set_text(0,key)
			temp.set_text(1,str(data["total_stats"][key]))
	if(do_online):
		


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Data/Scences/MainMenu.tscn")
	


func _on_leaderbroad_pressed() -> void:
	$"Stat Card".hide()
	$Leaderboard.show()


func _on_back_pressed() -> void:
	$"Stat Card".show()
	$Leaderboard.hide()
