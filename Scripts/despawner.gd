extends Node
class_name Despawner


@export var life_span: float = 10
@export var start_timer_on_ready: bool = true


func _ready():
	if start_timer_on_ready:
		despawn_timer()


func despawn_timer():
	if life_span < 0:
		return
	await get_tree().create_timer(life_span).timeout
	if get_parent():
		get_parent().queue_free()
