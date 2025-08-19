extends Control

signal game_paused(state:bool)

var is_game_paused:=false
@export_category("Other UI")
@export var Moblie_UI:Control
@export_category("Sounds")
@export var button_hovered:AudioStreamPlayer3D

func pause_game():
	var menu_tween:= create_tween()
	menu_tween.tween_property(self,"position",Vector2(0,0),0.1)

func _ready() -> void:
	bind_hover_noise()
	

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Escape")):
		is_game_paused=true
		Moblie_UI.hide()
		game_paused.emit(is_game_paused)
		pause_game()
		


func _on_resume_button_down() -> void:
	is_game_paused=false
	Moblie_UI.show()
	game_paused.emit(is_game_paused)
	var menu_tween:= create_tween()

	menu_tween.tween_property(self,"position",Vector2(-600,0),0.1)


func _on_quit_button_down() -> void:
	var end_game: Node3D = load("res://Data/Scences/MainMenu.tscn").instantiate()
	self.get_tree().root.get_node("Game").queue_free()
	self.get_tree().root.add_child(end_game)
	get_tree().current_scene=end_game

func bind_hover_noise():
	for child in get_children():
		if child.is_class("Button"):
			child.mouse_entered.connect(play_hover_noise)

func play_hover_noise():
	button_hovered.play()
	

func _on_quit_game_button_down() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	is_game_paused=true
	Moblie_UI.hide()
	game_paused.emit(is_game_paused)
	pause_game()
