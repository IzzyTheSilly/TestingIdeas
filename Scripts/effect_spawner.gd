extends Node
class_name EffectSpawner


@export var effect_scene: PackedScene


func spawn_effect(effect_position: Vector2 = Vector2.ZERO):
	var effect: Node2D = effect_scene.instantiate()
	if effect_position:
		effect.global_position = effect_position
	else:
		effect.global_position = get_parent().global_position
	get_parent().get_parent().add_child(effect)
