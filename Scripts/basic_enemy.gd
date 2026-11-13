extends BaseEnemy
class_name BasicEnemy


signal died(enemy: BasicEnemy)


@export var speed: float = 100
@export var follow_player: bool = true
@export var healing_object_scene: PackedScene
@export_range(0, 1) var heal_drop_chance: float
var direction: Vector2


func _process(delta):
	if follow_player:
		direction = player.global_position - global_position
	elif direction == Vector2.ZERO:
		direction = player.global_position - global_position
	
	direction = direction.normalized()
	position += direction * delta * speed


func _on_health_drained():
	died.emit(self)
	if randf_range(0, 1) < heal_drop_chance:
		var healing_object = healing_object_scene.instantiate()
		healing_object.global_position = global_position
		get_tree().current_scene.add_child(healing_object)
	queue_free()


func _on_body_entered(body):
	if body is Player:
		if body.velocity.length() > body.speed:
			queue_free()
