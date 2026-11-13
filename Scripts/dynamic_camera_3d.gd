extends Camera3D


@export var follow_object: Node3D
@export var offset: Vector3


func _process(delta: float) -> void:
	position = follow_object.position + offset
