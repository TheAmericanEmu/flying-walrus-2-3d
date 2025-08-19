extends RigidBody3D

signal hit_player(damnge:int)


var rng = RandomNumberGenerator.new()
var speed:float=-rng.randf_range(15,35)
func _init() -> void:
	self.linear_velocity.x=speed

func _process(delta: float) -> void:
	self.linear_velocity.x=speed
	if(self.position.x<-70.873):
		print("Pruged",self)
		self.queue_free()
	$run.play()

func kill():
	pass


func _on_body_entered(body: Node) -> void:
		if(body.name=="Walrus"):
			self.queue_free()
			hit_player.emit(10)
