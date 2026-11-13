extends Node
class_name Spawner


@export var object_spawned: PackedScene
@export var spawn_range_max: float = 300
@export var spawn_range_min: float = 150
@export var spawn_cooldown: float = 1
@export var start_on_ready: bool = true
@export var spawn_point: Node2D

var stopping: bool = false


func _ready():
	if start_on_ready:
		spawn_timer()


func start_timer():
	stopping = false
	spawn_timer()


func stop_timer():
	stopping = true


func spawn_timer():
	await get_tree().create_timer(spawn_cooldown).timeout
	var object = prepare_object()
	add_child(object)
	var random_pos: Vector2
	random_pos.x = randi_range(spawn_range_min, spawn_range_max)
	random_pos = random_pos.rotated(randf_range(0, TAU))
	random_pos += spawn_point.position
	object.position = random_pos
	if !stopping:
		spawn_timer()


func prepare_object() -> Node2D:
	var object: Node2D = object_spawned.instantiate()
	return object
