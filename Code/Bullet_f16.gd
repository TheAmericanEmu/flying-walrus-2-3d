extends RigidBody3D

signal hit_player

var y:float=0
var z:float = 0
func _on_body_entered(body: Node) -> void:
	if(body.name=="Walrus"):
		hit_player.emit()
		queue_free()
	#print(body.name)
	
func _init() -> void:
	self.add_to_group("20mm")
func  set_pos():
	y=position.y
	z=position.z
	self.linear_velocity.x=-100
func _process(delta: float) -> void:
	pass
