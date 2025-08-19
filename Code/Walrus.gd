extends CharacterBody3D

var controls_enabled:bool=true
var energy:float=100
var total_bullets_fired:int=0



@export var cooldown:Timer
@export var collider:CollisionShape3D

@export_category("Sounds")
@export var lazerSoundEffect:AudioStreamPlayer3D
@export var JetPackSoundEffect:AudioStreamPlayer3D
@export var damageTakenSoundEffect:AudioStreamPlayer3D
@export var HealedSoundEffect:AudioStreamPlayer3D
@export var missile_lock_sound:AudioStreamPlayer3D


var game_paused := false


signal charge_update(charge:float)
signal finshed_lock


func _physics_process(delta: float) -> void:
	if(game_paused==true):
		return
	if(Input.is_action_pressed("Jump") and controls_enabled):
		velocity.y+=0.2
		rotation_degrees.x=-45
		if(JetPackSoundEffect.playing==false):
			
			JetPackSoundEffect.play()
	elif(Input.is_action_pressed("Drop") and controls_enabled):
		velocity.y-=0.2
		rotation_degrees.x=45
		if(JetPackSoundEffect.playing==false):
			
			JetPackSoundEffect.play()
	else:
		JetPackSoundEffect.stop()
		velocity.y-=0.1
		rotation_degrees.x=0
		pass
	charge_update.emit(energy)
	if(self.position.y>17.516):
		self.position = Vector3(self.position.x,15,self.position.z)
	elif(self.position.y<-16.29):
		self.position = Vector3(self.position.x,-15,self.position.z)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if(event.is_action_released("Shoot") and energy>=0 and controls_enabled):
		cooldown.stop()
		lazerSoundEffect.play()
		var bullet:RigidBody3D = load("res://Data/Bullets/Debug.tscn").instantiate()
		bullet.position=Vector3(position.x+2,position.y,position.z)
		bullet.name="bullet"
		total_bullets_fired+=1
		energy-=1.25*total_bullets_fired
		print(energy)
		add_sibling(bullet)
	if(event.is_action_released("Shoot")==false and cooldown.is_stopped()==true and controls_enabled):
		cooldown.start(2)

	



func on_player_died() -> void:
	controls_enabled=false
	collider.disabled=true
	
func recharge():
	print("Recharged")
	total_bullets_fired=0
	energy=100

var old_heath=0
func on_player_hurt(health: int) -> void:
	print("Play Sound")
	if health>=old_heath:
		HealedSoundEffect.play()
	else:
		damageTakenSoundEffect.play()
	old_heath=health


func on_shoot_pressed() -> void:
	print("Shoot")
	Input.action_press("Shoot")


func _on_jump_pressed() -> void:
	Input.action_press("Jump")


func _on_jump_released() -> void:
	Input.action_release("Jump")


func _on_shoot_released() -> void:
	if(energy>=0 and controls_enabled):
		cooldown.stop()
		lazerSoundEffect.play()
		var bullet:RigidBody3D = load("res://Data/Bullets/Debug.tscn").instantiate()
		bullet.position=Vector3(position.x+2,position.y,position.z)
		total_bullets_fired+=1
		energy-=1.25*total_bullets_fired
		print(energy)
		add_sibling(bullet)
	if(cooldown.is_stopped()==true and controls_enabled):
		cooldown.start(2)
		cooldown.timeout.connect(recharge)


func _on_dive_pressed() -> void:
	Input.action_press("Drop")
	pass # Replace with function body.


func _on_dive_released() -> void:
	Input.action_release("Drop")
	pass # Replace with function body.


func _on_puase_menu_game_paused(state:bool) -> void:
	game_paused=state

func _ready() -> void:
	cooldown.timeout.connect(recharge)
	
func missile_lock():
	missile_lock_sound.play()
	await missile_lock_sound.finished
	finshed_lock.emit()
	
