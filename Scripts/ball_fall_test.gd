extends RigidBody2D


@export var testing_fall: bool = true
@export var health: Health


func _ready():
	if testing_fall:
		position.y = -1500


func _process(delta):
	if testing_fall and position.y >= 0:
		print(linear_velocity)


func _on_health_drained():
	queue_free()
