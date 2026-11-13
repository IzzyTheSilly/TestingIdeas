extends Attack
class_name BaseBullet


@export var bullet_pierce: float = 0

var velocity: Vector2 = Vector2(0, 0)


func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	position += delta * velocity


func set_velocity(new_velocity: Vector2):
	velocity = new_velocity


func _on_area_entered(area: Area2D):
	if area.collision_layer == 1 << (3 - 1):
		if bullet_pierce <= 0:
			queue_free()
		else:
			bullet_pierce -= 1
	elif area.collision_layer == 1 << (2 - 1):
		queue_free()


func _on_body_entered(body: Node2D):
	if body is TileMap:
		var tileset: TileSet = body.tile_set
		var collision_layer: int = tileset.get_physics_layer_collision_layer(0)
		if collision_layer == 2:
			queue_free()
