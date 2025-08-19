extends RigidBody3D

func _on_body_entered(body: Node) -> void:
	if(body.is_in_group("killable")):
		body.call("kill")
		queue_free()
	
func _init() -> void:
	self.linear_velocity.x=20
func _process(delta: float) -> void:
	if (self.position.x>35.347):
		print("Pruged")
		self.queue_free()
		
	pass
