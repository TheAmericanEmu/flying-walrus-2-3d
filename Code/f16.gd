class_name f16 extends RigidBody3D

signal killed
signal hit_player(damnge:int)

var bullet  = preload("res://Data/Bullets/20mm.tscn")
var timer=0
var counter=0
@export var deathSound:AudioStreamPlayer3D
@export var bullet_spawn:MeshInstance3D
@export var gun_shot_fx:AudioStreamPlayer3D
var rng = RandomNumberGenerator.new()
var speed:float=-rng.randf_range(30,35)



func _init() -> void:
	self.linear_velocity.x=speed

func _process(delta: float) -> void:
	timer+=1
	self.linear_velocity.x=speed
	if(timer>=15):	
		if(counter==0):
			gun_shot_fx.play()
			counter+=1
		var new_bullet:RigidBody3D = bullet.instantiate()
		new_bullet.position= Vector3(position.x,position.y-1,position.z)
		new_bullet.call("set_pos")
		new_bullet.linear_velocity.x=self.linear_velocity.x-15
		new_bullet.connect("hit_player", hit_bullet_player)
		#print(new_bullet.position)
		get_tree().root.add_child(new_bullet)
		new_bullet.add_to_group("killable")
		timer=0
func hit_bullet_player():
	self.hit_player.emit(1)

func kill():
	deathSound.play()
	self.remove_child(deathSound)
	get_tree().root.add_child(deathSound)
	emit_signal("killed")
	self.queue_free()


func _on_body_entered(body: Node) -> void:
		if(body.is_in_group("Player")):
			hit_player.emit(10)
			self.queue_free()


func _on_mm_gunshot_finished() -> void:
	if(counter<5):
		gun_shot_fx.play()
		counter+=1
