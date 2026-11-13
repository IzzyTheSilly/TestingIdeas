extends Area2D
class_name Bouba


signal get
signal get_this_item


func _on_body_entered(body):
	get.emit()
	get_this_item.emit()
	queue_free()


func set_life_span(amount: float) -> void:
	$Despawner.life_span = amount
