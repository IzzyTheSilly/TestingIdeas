extends Node2D


func _ready():
	set_max_health_ui($Objects/ActionRPGPlayer/Health.max_health)


func _on_test_item_player_in_range():
	$Player/DynamicCamera/UIStuff/PickupPoppup.visible = true


func _on_test_item_player_not_in_range():
	$Player/DynamicCamera/UIStuff/PickupPoppup.visible = false


func _on_action_rpg_player_died():
	get_tree().reload_current_scene()


func _on_action_rpg_player_health_changed(health):
	$CanvasLayer/FullHearts.size.x = 15 * health


func set_max_health_ui(max_health: int):
	$CanvasLayer/EmptyHearts.size.x = 15 * max_health
