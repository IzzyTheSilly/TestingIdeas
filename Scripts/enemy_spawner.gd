extends Spawner
class_name EnemySpawner


@export var player: CharacterBody2D


func prepare_object() -> Node2D:
	var object: BaseEnemy = object_spawned.instantiate()
	object.player = player
	return object
