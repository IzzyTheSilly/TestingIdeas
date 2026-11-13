extends Node2D
class_name TrailOfTorment


@export var dev_mode: bool = false
@export var slow_time_speed: float = 1
@export var bouba_parent: Node


func _on_player_died():
	if !dev_mode:
		$Player.position = $SpawnPoint.position


func _process(delta):
	if Input.is_action_just_pressed("toggle_dev_mode"):
		dev_mode = !dev_mode
		$Player/TextureRect.visible = !$Player/TextureRect.visible
		if dev_mode:
			$TileMap.set_collision_visibility_mode(TileMap.VISIBILITY_MODE_FORCE_SHOW)
			remove_boubas()
		else:
			$TileMap.set_collision_visibility_mode(TileMap.VISIBILITY_MODE_DEFAULT)
	
	if Input.is_action_just_pressed("slow_time"):
		if Engine.time_scale == 1:
			Engine.time_scale = slow_time_speed
			remove_boubas()
		else:
			Engine.time_scale = 1
	
	if Input.is_action_just_pressed("set_spawn"):
		$SpawnPoint.position = $Player.position
	
	if Input.is_action_just_pressed("return_to_spawn"):
		dev_mode = false
		$Player.position = Vector2(-1, -61)
		$SpawnPoint.position = $Player.position
		Engine.time_scale = 1
		$Player/TextureRect.visible = false
		$TileMap.set_collision_visibility_mode(TileMap.VISIBILITY_MODE_DEFAULT)
		for bouba: Bouba in bouba_parent.get_children():
			bouba.monitoring = true
			bouba.visible = true


func remove_boubas() -> void:
	for bouba: Bouba in bouba_parent.get_children():
		bouba.monitoring = false
		bouba.visible = false
