extends AnimatedSprite2D
class_name DespawnEffect


func _ready():
	play("effect")
	animation_finished.connect(_on_animation_finished)


func _on_animation_finished():
	queue_free()
