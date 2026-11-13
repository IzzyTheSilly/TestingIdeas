extends StaticBody2D


func _on_health_drained():
	$EffectSpawner.spawn_effect()
	queue_free()
