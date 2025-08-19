extends Control

@export var health_bar:ProgressBar
@export var score_label:Label
@export var charge_bar:ProgressBar


func _on_emeny_handler_player_hurt(health: int) -> void:
	health_bar.value=health

func _on_emeny_handler_player_died() -> void:
	self.visible=false


func _on_walrus_charge_update(charge: float) -> void:
	charge_bar.value=charge


func on_update_kill_count(kills: int) -> void:
	score_label.text=str(kills)
