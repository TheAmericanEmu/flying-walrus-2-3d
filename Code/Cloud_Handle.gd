extends Node3D

var cloud_template = preload("res://Data/BackgroundObjects/Cloud/cloud.tscn")
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	for i in range(10):
		var new_cloud:Node3D=cloud_template.instantiate()
		new_cloud.position = Vector3(3,0,-1.956)
		add_child(new_cloud)
		print(new_cloud.position)
