extends Node3D

var speed:int=1

func _init() -> void:
	pass

func _process(delta: float) -> void:
	print(self.position)
	self.position.x-=speed
