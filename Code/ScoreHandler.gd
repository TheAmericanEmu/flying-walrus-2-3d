extends Node


var types_killed:Dictionary = {}
var next_score_target = 25
var timer = Timer.new()

signal update_kill_count(kills:int)
signal push_new_emeny

func _ready() -> void:
	update_kill_count.emit(0)

func _on_timer_timeout():
	load_death_scene()
	print("Timer finished!")


func get_total():
	var total:int = 0
	for key in types_killed.keys():
		total+=types_killed[key]
	return total


func update_score(type: int) -> void:
	types_killed.get_or_add(type,0)
	if(types_killed[type]==null):
		types_killed[type]==1
	else:
		types_killed[type]+=1
	print(types_killed)
	do_kill_math()
	

	
	
func do_kill_math():
	var total = get_total()
	if(total>=next_score_target):
		next_score_target+=25
		push_new_emeny.emit()
	update_kill_count.emit(total)
	


func load_death_scene():
	var end_game: Node3D = load("res://Data/Scences/end_game.tscn").instantiate()
	end_game.call("create_grave", get_total())
	end_game.call("create_battle_report",types_killed)
	self.get_tree().root.get_node("Game").queue_free()
	self.get_tree().root.add_child(end_game)



func player_died() -> void:
	await get_tree().create_timer(2).timeout 
	load_death_scene()
