extends Node2D
class_name RoadRepeater


@export var road_sprites: Array[Sprite2D]
@export var timer: Timer
@export var speed: int
var tracker: int = 0
const sprite_height: int = 1080
var is_parked: bool = false


func _ready() -> void:
	timer.wait_time = sprite_height*0.3/speed


func _process(delta: float) -> void:
	if !is_parked:
		for road_sprite: Sprite2D in road_sprites:
			road_sprite.position.y += speed * delta


func _on_timer_timeout() -> void:
	road_sprites[tracker].position.y -= sprite_height*0.9
	tracker += 1
	if tracker >= road_sprites.size():
		tracker = 0


func car_parked() -> void:
	is_parked = true
	timer.stop()
