extends Camera2D
class_name DynamicCamera


@export var player: CharacterBody2D
@export var follow_object: Node2D
@export_enum("None", "Use Velocity", "Use Mouse Position") var camera_interpolation_mode: int
@export var interpolation_speed: float = 3
@export var offset_distance: float = 0.1
@export var cam_margins: float = 0.2
@export var cam_size: float = 0.3
@export var perlin_noise: FastNoiseLite
@export var shake_amplitude: float = 4
@export var shake_speed: float = 0.2
@export var top_left_limit: Node2D
@export var bottom_right_limit: Node2D

var is_moving: bool = true
var previous_shake_amplitude: float


func _ready():
	set_camera_size(cam_size)
	set_camera_margins(cam_margins)
	if top_left_limit and bottom_right_limit:
		limit_left = top_left_limit.position.x
		limit_top = top_left_limit.position.y
		limit_right = bottom_right_limit.position.x
		limit_bottom = bottom_right_limit.position.y


func _process(delta):
	if is_moving and player:
		var final_position: Vector2
		
		if perlin_noise != null and player.velocity != Vector2.ZERO:
			final_position.x += perlin_noise.get_noise_1d(Time.get_ticks_msec() * shake_speed) * shake_amplitude
			final_position.y += perlin_noise.get_noise_1d(-Time.get_ticks_msec() * shake_speed) * shake_amplitude
		
		if camera_interpolation_mode == 1:
			final_position += position.lerp(player.velocity * offset_distance, delta * interpolation_speed)
		elif camera_interpolation_mode == 2:
			var direction: Vector2 = get_global_mouse_position() - player.position
			direction = direction.normalized()
			final_position += position.lerp(direction * 300 * offset_distance, delta * interpolation_speed)
		
		position = final_position
	elif follow_object:
		position = follow_object.position


func set_camera_size(size: float):
	zoom = Vector2(1 / size, 1 / size)


func set_camera_margins(margin: float):
	drag_top_margin = margin
	drag_left_margin = margin
	drag_right_margin = margin
	drag_bottom_margin = margin


func stop_camera_shake():
	previous_shake_amplitude = shake_amplitude
	shake_amplitude = 0


func start_camera_shake():
	shake_amplitude = previous_shake_amplitude


func _on_top_down_world_inventory_toggled(state):
	if state:
		is_moving = false
	else:
		is_moving = true
