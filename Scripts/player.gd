extends CharacterBody2D
class_name Player


signal died
signal score_changed(amount: int)

signal health_changed(health: int)
signal collect_boubucks
signal take_damage
signal give_kel_money
signal give_kel_not_enough_money

signal jumped
signal dashed


@export var speed: float = 300.0
@export var inertia: float = 5
@export var health: int = 1
var layer_of_collision
var is_near_kel: bool = false


@export_group("Platformer Parameters")
@export var jump_velocity: float = -400
@export var terminal_velocity: float = 500
@export var jump_cancel_strength: float = 3
@export var gravity: float = 980
var buffer_jump_timer: float = 0
@export var buffer_jump_timer_max: float = 0.1
var coyote_jump_timer: float = 0
@export var coyote_jump_timer_max: float = 0.1
var can_double_jump: bool = false
@export var floor_friction: float = 1.4
@export var down_force: float = 1.3
@export var forward_dash_force: float = 2.5
var can_dash: bool = false
@export var wall_friction: float = 2
var wall_jump_pause_timer: float = 0
@export var wall_jump_pause_timer_max: float = 0.1
@export var wall_jump_move_slowdown: float = 1.4
@export var wall_jump_force: float = -300
@export_group("")

@export_group("Topdown Parameters")
@export var dash_force: float = 3.2
@export var dash_cooldown: float = 0.8
var dash_timer: float = 0
@export var sneak_slowness: float = 1.6
@export_enum("None", "X Axis Only", "Y Axis Only") var axis_lock: int
@export_group("")

@export_enum("Platformer", "Topdown") var control_mode: int


func _ready():
	if control_mode == 0: #PLATFORMER
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	elif control_mode == 1: #TOPDOWN
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	var health_component: Health = get_node("%Health")
	health_component.max_health = health
	health_component.health = health


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and is_near_kel:
		if GlobalStats.boubucks >= 15:
			GlobalStats.boubucks -= 15
			give_kel_money.emit()
		else:
			give_kel_not_enough_money.emit()


func _physics_process(delta):
	layer_of_collision = 0
	if control_mode == 0: #PLATFORMER
		process_platformer(delta)
	elif control_mode == 1: #TOPDOWN
		process_topdown(delta)
	process_misc_input(delta)
	
	if !move_and_slide():
		return
	
	if get_last_slide_collision().get_collider():
			layer_of_collision = PhysicsServer2D.body_get_collision_layer(get_last_slide_collision().get_collider_rid())
	
	if layer_of_collision == 1 << (3 - 1):
		handle_dangerous_collision()
	if layer_of_collision == 1 << (2 - 1):
		if !is_pressing_direction() and control_mode == 1:
			velocity = Vector2.ZERO


func process_platformer(delta):
	var final_speed: float = speed
	
	if (
			Input.is_action_just_pressed("dash") 
			and (!is_on_floor()) and (!is_on_wall()) 
			and velocity.x != 0 
			and can_dash
		):
		if velocity.x > 0:
			velocity.x = speed * forward_dash_force
		else:
			velocity.x = speed * -forward_dash_force
		velocity.y = 0
		dashed.emit()
		can_dash = false
	
	if is_on_floor() or (is_on_wall() and is_pressing_horizontal_direction()):
		can_double_jump = true
		can_dash = true
		if not Input.is_action_pressed("up"):
			coyote_jump_timer = 0
		if is_on_wall() and is_pressing_horizontal_direction():
			if velocity.y < terminal_velocity / wall_friction:
				if velocity.y < 0:
					velocity.y += gravity * delta * wall_friction
				else:
					velocity.y += gravity * delta / wall_friction
			else:
				velocity.y -= gravity * delta / wall_friction
	else:
		if coyote_jump_timer <= coyote_jump_timer_max:
			coyote_jump_timer += delta
		if velocity.y < terminal_velocity:
			velocity.y += gravity * delta
		else:
			velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("up"):
		buffer_jump_timer = 0
	if buffer_jump_timer <= buffer_jump_timer_max:
		buffer_jump_timer += delta

	if (
			Input.is_action_pressed("up") 
			and ((buffer_jump_timer <= buffer_jump_timer_max and is_on_floor()) 
			or (coyote_jump_timer <= coyote_jump_timer_max and velocity.y > 0) and not is_on_wall())
		):
		velocity.y = jump_velocity
		buffer_jump_timer = buffer_jump_timer_max
		coyote_jump_timer = coyote_jump_timer_max
		jumped.emit()
	elif Input.is_action_just_pressed("up"):
		if can_double_jump and not (is_on_wall() and is_pressing_horizontal_direction()):
			velocity.y = jump_velocity
			jumped.emit()
			can_double_jump = false
		if is_on_wall() and is_pressing_horizontal_direction():
			velocity.y = jump_velocity
			jumped.emit()
			if Input.is_action_pressed("right"):
				velocity.x = wall_jump_force
			elif Input.is_action_pressed("left"):
				velocity.x = -wall_jump_force
			wall_jump_pause_timer = 0
	
	if wall_jump_pause_timer < wall_jump_pause_timer_max:
		wall_jump_pause_timer += delta
		final_speed = speed / wall_jump_move_slowdown
	else:
		final_speed = speed	
	
	var direction: float = Input.get_axis("left", "right")
	if direction:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * final_speed / floor_friction, final_speed / inertia / floor_friction)
		else:
			velocity.x = move_toward(velocity.x, direction * final_speed, final_speed / inertia)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, final_speed * floor_friction / inertia)
		else:
			velocity.x = move_toward(velocity.x, 0, final_speed / inertia)
	
	if Input.is_action_just_released("up") and velocity.y < 0 and jump_cancel_strength:
		velocity.y = velocity.y / jump_cancel_strength
	
	if Input.is_action_pressed("down"):
		if is_on_floor():
			velocity.x = velocity.x / down_force
		else:
			velocity.y += gravity * delta * down_force


func process_topdown(delta):
	var direction: Vector2
	if axis_lock != 2:
		direction.x = Input.get_axis("left", "right")
	if axis_lock != 1:
		direction.y = Input.get_axis("up", "down")
	
	if direction:
		direction = direction.normalized()
		velocity.x = move_toward(velocity.x, direction.x * speed, speed / inertia)
		velocity.y = move_toward(velocity.y, direction.y * speed, speed / inertia)
	else:
		velocity.x = move_toward(velocity.x, 0, speed / inertia)
		velocity.y = move_toward(velocity.y, 0, speed / inertia)
	
	if dash_timer < dash_cooldown:
		dash_timer += delta
	if Input.is_action_just_pressed("dash") and direction and dash_timer >= dash_cooldown:
		velocity = direction * speed * dash_force
		dash_timer = 0
	
	if Input.is_action_pressed("sneak") and direction:
		velocity = velocity / sneak_slowness


func process_misc_input(delta: float):
	if Input.is_action_just_pressed("return_to_spawn"):
		control_mode = 0
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	if Input.is_action_just_pressed("toggle_dev_mode"):
		if control_mode == 0:
			control_mode = 1
			motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		elif control_mode == 1:
			control_mode = 0
			motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED


func is_pressing_horizontal_direction() -> bool:
	return Input.is_action_pressed("left") or Input.is_action_pressed("right")


func is_pressing_vertical_direction() -> bool:
	return Input.is_action_pressed("up") or Input.is_action_pressed("down")


func is_pressing_direction() -> bool:
	return is_pressing_horizontal_direction() or is_pressing_vertical_direction()


func handle_dangerous_collision():
	died.emit()


func _on_collector_amount_collected_changed(amount):
	score_changed.emit(amount)
	collect_boubucks.emit()


func _on_assgore_truck_get_bouba() -> void:
	collect_boubucks.emit()


func _on_health_take_damage() -> void:
	take_damage.emit()


func car_parked() -> void:
	axis_lock = 0


func _on_health_health_changed(health: int) -> void:
	health_changed.emit(health)


func change_health(amount: int) -> void:
	%Health.change_health(amount)
