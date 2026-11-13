extends RigidBody3D
class_name Player3D


@export var speed: float = 10


func _process(delta: float) -> void:
	var direction: Vector2
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	
	if direction and linear_velocity.length() < 100:
		direction = direction.normalized()
		apply_force(Vector3(direction.x, 0, direction.y))
	
	if Input.is_action_pressed("jump") and linear_velocity.length() < 100:
		apply_force(Vector3.UP)
