extends Node2D
class_name BaseGun


@export var reload_interval: float = 0.2
var reload_timer: float = 0
@export var autoshooting: bool = false
@export var bullet_type: PackedScene
@export var bullet_parent: Node2D
@export var bullet_speed: float


func set_properties(new_bullet_type: PackedScene, new_bullet_parent: Node2D):
	bullet_type = new_bullet_type
	bullet_parent = new_bullet_parent


func shoot_bullet():
	pass


func _process(delta):
	if reload_timer < reload_interval:
		reload_timer += delta
	
	if Input.is_action_pressed("click") or autoshooting:
		if reload_timer >= reload_interval:
			reload_timer = 0
			shoot_bullet()
	
	if Input.is_action_just_pressed("toggle_autoshoot"):
		autoshooting = !autoshooting
