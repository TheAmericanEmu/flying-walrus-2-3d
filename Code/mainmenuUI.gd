extends Control

var current_save_game_verison=2

@export var credits_panel:Panel
@export var menu_panel:Panel
@export var credit_label:Label

@export_category("Sounds")
@export var button_hovered:AudioStreamPlayer3D
@export_category("Load Animiation")
@export var ani_time:float=2
@export var interval:float=0.5
@export var title:Node3D

var title_tween:Tween
var tweens:Array[Tween] = []

func load_credits_label():
	var file = FileAccess.open("res://Credits.txt",FileAccess.READ)
	credit_label.text=file.get_as_text()
	
func on_play_pressed() -> void:
	var game_instance:Node3D = load("res://Data/Scences/Game.tscn").instantiate()
	self.get_tree().root.get_node("mainmenu").queue_free()
	self.get_tree().root.add_child(game_instance)
	


func on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Data/Scences/credits.tscn")


func _on_return_pressed() -> void:
	credits_panel.visible=false
	menu_panel.visible=true
	


func on_exit_pressed() -> void:
	get_tree().quit()

var save_file_template:Dictionary={
	
	"cash":0,
	"rank":"Blubber Whelp, 1st Drip",
	#This all dict save game
	"total_stats":{
		"kills":0,
		"score":0,
		"cash":0
	},
	
	"version":2
}


func check_save_game():
	
	var save_game_path="user://user_data//save_data.json"
	if (FileAccess.file_exists(save_game_path)==false):
		DirAccess.make_dir_recursive_absolute("user://user_data//")
		var file:FileAccess = FileAccess.open(save_game_path,FileAccess.WRITE)
		file.store_string(JSON.stringify(save_file_template))
		file.close()
		print("Wrote New Save Game")
	else:
		var file = FileAccess.open(save_game_path,FileAccess.READ)
		var data:Dictionary = JSON.parse_string(file.get_as_text())
		if(data["version"]==current_save_game_verison):
			print("is a vaild save game")
		else:
			OS.alert("Your save game verison doesnt match","Uhh-Ohh")
			get_tree().quit(100)
		file.close()
		
var config_template={
	"use_online_mode":false,
	"web_server_address":"https://flying-walrus-game-server.onrender.com/",
	"username":"",
	"password":"",
	"uuid":""
}

func create_account():

func check_config():
	
	var save_game_path="user://user_data//config.json"
	if (FileAccess.file_exists(save_game_path)==false):
		DirAccess.make_dir_recursive_absolute("user://user_data//")
		var file:FileAccess = FileAccess.open(save_game_path,FileAccess.WRITE)
		$Online_Ofline.show()
		$"Online_Ofline/Play Online"
		file.store_string(JSON.stringify(config_template))
		file.close()
		print("Wrote New Save Game")
	else:
		var file = FileAccess.open(save_game_path,FileAccess.READ)
		var data:Dictionary = JSON.parse_string(file.get_as_text())
		print("config file exists")
		file.close()

func bind_hover_noise():
	for child:Button in $"Main Menu".get_children():
		child.mouse_entered.connect(play_hover_noise)

func play_hover_noise():
	button_hovered.play()

func create_load_ani():
	for child:Button in $"Main Menu".get_children():
		var tween:= create_tween()
		tween.tween_property(child,"position",child.position,ani_time)
		tween.stop()
		tween.set_ease(Tween.EASE_IN)
		tweens.append(tween)
		child.set_position(Vector2(child.position.x,child.position.y+100))
	print(tweens)
	title_tween= create_tween()
	title_tween.tween_property(title,"position",title.position,2)
	title.position.y=2.521
	title_tween.stop()
	
func play_load_ani():
	title_tween.play()
	for tween:Tween in tweens:
		await get_tree().create_timer(interval).timeout 
		tween.play()
	

func _ready() -> void:
	bind_hover_noise()
	check_save_game()
	check_config()
	create_load_ani()
	play_load_ani()


func _on_stats_pressed() -> void:
	get_tree().change_scene_to_file("res://Data/Scences/stats.tscn")
	pass # Replace with function body.
