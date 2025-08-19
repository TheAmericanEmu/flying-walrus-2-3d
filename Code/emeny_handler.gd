extends Node3D

var orca_preset:PackedScene = preload("res://Data/Animals/orca/orca.tscn")
var f16_preset:PackedScene = preload("res://Data/Animals/F16/F16.tscn")
var crab_preset:PackedScene = preload("res://Data/Animals/crab_missiles/crab_missiles.tscn")
var med_missile:PackedScene = preload("res://Data/Animals/medMissile/medkit.tscn")


var score: int = 0
var player_heatlh:int=100
var rng = RandomNumberGenerator.new()

var game_enabled=true


signal score_update(score:int)
signal update_score(type:int)
signal player_hurt(health:int)
signal player_died


@export var walrus:CharacterBody3D
@export_category("Game Config")
@export var max_enemys:int=4
@export var diff_up_intvel=20
@export var time_between_medkit_spawns:int=10
@export_category("Sound")
@export var missle_locked_sound:AudioStreamPlayer3D
@export var damageTakenSoundEffect:AudioStreamPlayer3D

var types=1
var timer = Timer.new()
var med_kit_timer:Timer

var time_since_start=1

var spawn_pool:Array=[new_orca]
var reserve_pool:Array=[new_16,new_crab]

var orca_killed = 0
var f16_killed = 0







func new_orca():
	var orca: RigidBody3D = orca_preset.instantiate()
	orca.position = Vector3(self.position.x,rng.randf_range(-15,15),self.position.z)
	orca.rotation_degrees.y = -90

	# Make sure the signal exists, then connect it
	orca.connect("killed", func(): update_score.emit(0))
	orca.connect("hit_player", self.hit_player)
	orca.add_to_group("killable")
	add_child(orca)

func new_16():
	var f16: RigidBody3D = f16_preset.instantiate()
	f16.position = Vector3(self.position.x,rng.randf_range(-15,15),self.position.z)
	f16.rotation_degrees.y = -90

	# Make sure the signal exists, then connect it
	f16.connect("killed",func(): update_score.emit(1))
	f16.connect("hit_player", self.hit_player)
	add_child(f16)
	f16.add_to_group("killable")

func new_crab():
	var crab: RigidBody3D = crab_preset.instantiate()
	crab.position = Vector3(self.position.x,rng.randf_range(-15,15),self.position.z)
	crab.connect("killed",func(): update_score.emit(2))
	crab.connect("hit_player", self.hit_player)
	crab.connect("started_lock",start_lock)
	# Wrap in a local variable to properly isolate the signal connection
	
	
	crab.add_to_group("killable")
	add_child(crab)

func start_lock(crab:RigidBody3D):
	var temp_sound:AudioStreamPlayer3D= missle_locked_sound.duplicate()
	walrus.add_child(temp_sound)
	temp_sound.position=walrus.position
	temp_sound.play()
	await temp_sound.finished
	if(crab!=null):
		crab.locked_missile()
	temp_sound.queue_free()
	

func spawn_missile():
	var missile = med_missile.instantiate()
	missile.connect("hit_player",heal_player)
	missile.position = Vector3(self.position.x,rng.randf_range(-15,15),self.position.z)
	missile.add_to_group("killable")
	add_child(missile)

func heal_player(damage):
	player_heatlh+=damage
	player_hurt.emit(player_heatlh)

func _ready() -> void:
	med_kit_timer=Timer.new()
	med_kit_timer.wait_time=time_between_medkit_spawns
	med_kit_timer.start()
	med_kit_timer.autostart=true
	player_hurt.emit(player_heatlh)
	new_orca()

func _physics_process(delta: float) -> void:
	for child:Node3D in get_children():
		if child.is_in_group("Missile"):
			child.set_y(walrus.position.y)

	
	
func _process(delta: float) -> void:	
	if(self.get_child_count()<max_enemys and game_enabled):
		spawn_pool.pick_random().call()
		if(randi_range(0,100)>75 and med_kit_timer.is_stopped()):
			med_kit_timer.start(time_between_medkit_spawns)
			spawn_missile()



func hit_player(damnge):
	player_heatlh-=damnge
	player_hurt.emit(player_heatlh)
	if(player_heatlh<=0):
		player_died.emit()
		game_enabled=false
	print("Player Health:", player_heatlh)


func _on_score_handler_push_new_emeny() -> void:
	if(len(reserve_pool)!=0):
		var new_emeny=reserve_pool.pop_at(0)
		spawn_pool.append(new_emeny)
	max_enemys+=1


func _on_puase_menu_game_paused(state: bool) -> void:
	game_enabled=not state
	if game_enabled==false:
		for child in get_children():
			child.queue_free()
	
		
