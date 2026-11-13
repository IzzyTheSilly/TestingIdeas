extends Sprite2D
class_name DessRunning


var is_parked: bool = false


func _process(delta: float) -> void:
	if is_parked:
		position.y -= 300 * delta


func _on_dess_running_timer_timeout() -> void:
	scale.x = -scale.x


func car_parked() -> void:
	is_parked = true
