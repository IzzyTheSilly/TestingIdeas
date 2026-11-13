extends Node2D
class_name Bergentrucking


@export var road_repeater: RoadRepeater
@export var dess_running: DessRunning
@export var falling_obstacle_spawner: FallingObstacleSpawner
@export var player: Player
@export var truck: Sprite2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		road_repeater.car_parked()
		dess_running.car_parked()
		falling_obstacle_spawner.car_parked()
		player.car_parked()
		truck.car_parked()
		var truck_pos: Vector2 = truck.global_position
		player.remove_child(truck)
		add_child(truck)
		truck.position = truck_pos
