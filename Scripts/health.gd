extends Node
class_name Health


signal health_drained
signal health_changed(health: int)
signal take_damage


@export var max_health: int = 5
var health: int


func _ready():
	health = max_health


func set_health(amount: int):
	health = amount


func reset_health():
	health = max_health


func change_health(amount: int):
	if amount < 0:
		take_damage.emit()
	health += amount
	if health > max_health:
		health = max_health
	if health <= 0:
		health_drained.emit()
	
	health_changed.emit(health)
