extends Spawner
class_name BoubaSpawner


@export var bouba_life_span: float


func prepare_object() -> Node2D:
	var object: Bouba = object_spawned.instantiate()
	object.set_life_span(bouba_life_span)
	return object
