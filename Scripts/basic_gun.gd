extends BaseGun
class_name BasicGun


@export var barrel_amount: int = 1
@export_range(0, TAU) var spread: float = 0


func shoot_bullet():
	for i in barrel_amount:
		var bullet: BaseBullet = bullet_type.instantiate()
		bullet_parent.add_child(bullet)
		bullet.position = global_position
		var bullet_direction: Vector2 = get_global_mouse_position() - global_position
		bullet_direction = bullet_direction.normalized()
		var rotation: float = TAU / barrel_amount 
		bullet_direction = bullet_direction.rotated(rotation * i + randf_range(-spread, spread))
		bullet.set_velocity(bullet_direction * bullet_speed)
