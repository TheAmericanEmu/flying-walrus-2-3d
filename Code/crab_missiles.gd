extends Node3D


@export var speed:int=10
@export var boost_timer_delay:int =3
@export var death_sound:AudioStreamPlayer3D
var boost_timer:SceneTreeTimer
var locked=false 

signal hit_player
signal killed
signal started_lock(crab:RigidBody3D)

func _ready() -> void:
	boost_timer=get_tree().create_timer(boost_timer_delay)
	boost_timer.timeout.connect(boost_timer_ends)
	pass

func boost_timer_ends():
	started_lock.emit(self)
	
func locked_missile():
	$Fire.play()
	speed=50
	locked=true
func _process(delta: float) -> void:
	self.linear_velocity.x=-speed
	if(self.position.x<-70.873):
		print("Pruged",self)
		self.queue_free()
	if(locked==true):
		$run.play()
	
func set_y(y:float):
	if locked==false:
		self.position.y=y
	
func kill():
	death_sound.play()
	self.remove_child(death_sound)
	get_tree().root.add_child(death_sound)
	emit_signal("killed")
	self.queue_free()


func _on_body_entered(body: Node) -> void:
	if(body.name=="Walrus"):
		self.queue_free()
		hit_player.emit(10)
