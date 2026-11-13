extends Node2D
class_name FallingObstacleSpawner


@export_enum("Spawner Based", "Instance Based") var type: int
@export var spawnable_falling_obstacle_base: PackedScene
@export var left_spawn_limit: Marker2D
@export var right_spawn_limit: Marker2D
@export var spawnable_obstacles_array: Array[SpawnableFallingObstacleInfo]
var total_probability: int


func _ready() -> void:
	for spawnable_obstacle: SpawnableFallingObstacleInfo in spawnable_obstacles_array:
		total_probability += spawnable_obstacle.probability


func pick_random_obstacle_index() -> int:
	var random: int = randi_range(1, total_probability)
	var tracker: int
	var selected_obstacle: int
	
	for spawnable_obstacle: SpawnableFallingObstacleInfo in spawnable_obstacles_array:
		tracker += spawnable_obstacle.probability
		if tracker >= random:
			break
		selected_obstacle += 1
	
	return selected_obstacle


func spawn_obstacle() -> void:
	var obstacle: SpawnableFallingObstacleBase = spawnable_falling_obstacle_base.instantiate()
	obstacle.info = spawnable_obstacles_array[pick_random_obstacle_index()]
	obstacle.position = pick_random_position()
	add_child(obstacle)


func pick_random_position() -> Vector2:
	var position: Vector2
	position.x = randf_range(left_spawn_limit.position.x, right_spawn_limit.position.x)
	position.y = -50
	
	return position


func _on_spawner_timer_timeout() -> void:
	spawn_obstacle()


func car_parked() -> void:
	for child: Node in get_children():
		if child is Timer:
			child.stop()
		if child is SpawnableFallingObstacleBase:
			queue_free.call_deferred()
