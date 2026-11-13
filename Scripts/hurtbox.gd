extends Area2D
class_name Hurtbox


signal hit


@export var health: Health
@onready var parent: Node = get_parent()

var invincible: bool = false


func _ready():
	area_entered.connect(hurtbox_hit)


func hurtbox_hit(area: Area2D):
	if invincible:
		return
	
	if parent is Player:
		if parent.velocity.length() > parent.speed:
			return
	
	if area is Attack:
		health.change_health(-area.attack_damage)
	else:
		health.change_health(-1)
		print(health.health)
	
	hit.emit()


func set_invincibility(state: bool):
	if state:
		invincible = true
		set_deferred("monitoring", false)
	else:
		invincible = false
		set_deferred("monitoring", true)
