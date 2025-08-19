extends Panel

func death_bar_Tween():
	# Get the current camera and create a tween
	var tween = create_tween()
	# Tween the camera's position to the target position
	tween.tween_property(self, "scale", Vector2(1.0,1), 2)
	# Optional: You can add easing or other effects to the tween.
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUINT)



func _on_emeny_handler_player_died() -> void:
	self.visible=true
	death_bar_Tween()
