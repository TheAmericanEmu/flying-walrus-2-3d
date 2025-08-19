class_name orca extends RigidBody3D

signal killed
signal hit_player(damnge:int)

@export var deathSound:AudioStreamPlayer3D
var rng = RandomNumberGenerator.new()
var speed:float=-rng.randf_range(15,35)
func _init() -> void:
	self.linear_velocity.x=speed

func _process(delta: float) -> void:
	self.linear_velocity.x=speed
	if(self.position.x<-70.873):
		print("Pruged",self)
		self.queue_free()

func kill():
	deathSound.play()
	self.remove_child(deathSound)
	get_tree().root.add_child(deathSound)
	emit_signal("killed")
	self.queue_free()


func _on_body_entered(body: Node) -> void:
		if(body.name=="Walrus"):
			self.queue_free()
			hit_player.emit(10)
