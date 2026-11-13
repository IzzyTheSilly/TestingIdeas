extends Node2D
class_name SpawnableFallingObstacleBase


@export var text_rect: TextureRect
var info: SpawnableFallingObstacleInfo
var speed: int
var is_bouba: bool
var is_baby: bool
var is_roadblock: bool


func _ready() -> void:
	text_rect.texture = info.sprite
	speed = info.speed
	is_bouba = info.is_bouba
	is_baby = info.is_baby
	is_roadblock = info.is_roadblock


func _process(delta: float) -> void:
	position.y += speed * delta
