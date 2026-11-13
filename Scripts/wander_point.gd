extends Timer


@export var wander_range: float = 32

@onready var start_position: Vector2 = get_parent().global_position
@onready var target_position: Vector2 = get_parent().global_position


func update_target_position():
	var target_vector: Vector2 = Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range))
	target_position = start_position + target_vector


func _on_timeout():
	update_target_position()
