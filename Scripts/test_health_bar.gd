extends Sprite2D


@export var player: Player
var max_health: float


func _ready() -> void:
	max_health = player.health
	material.set_shader_parameter("health_ratio", 1)
	material.set_shader_parameter("is_flashing", false)
	material.set_shader_parameter("x_to_y_ratio", scale.x / scale.y)


func _on_player_health_changed(health: int) -> void:
	material.set_shader_parameter("health_ratio", health / max_health)
	if health < 4:
		material.set_shader_parameter("is_flashing", true)
	match health:
		2:
			material.set_shader_parameter("flash_speed", 8)
		1:
			material.set_shader_parameter("flash_speed", 12)
