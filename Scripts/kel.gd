extends Sprite2D


var player: Player


func _on_kel_interaction_area_area_entered(area: Area2D) -> void:
	var parent: Node = area.get_parent()
	if parent is Player:
		player = parent
		player.is_near_kel = true


func _on_kel_interaction_area_area_exited(area: Area2D) -> void:
	player.is_near_kel = false
