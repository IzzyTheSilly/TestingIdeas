extends CharacterBody2D
class_name ActionRPGPlayer


signal died
signal health_changed(health: int)


enum PlayerState {
	MOVE,
	ROLL,
	ATTACK,
}
var player_state: PlayerState = PlayerState.MOVE

@export var speed: float = 200
@export var acceleration: float = 120
@export var roll_speed: float = 400
@export var friction: float = 120
@export var inertia: float = 5
@export var invincibility_time: float = 1

var roll_vector: Vector2 = Vector2.DOWN

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var attack_hitbox: AttackHitbox = $AttackHitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var health: Health = $Health


func _ready():
	animation_tree.active = true
	invincibility_timer.wait_time = invincibility_time

func _physics_process(delta):
	match player_state:
		PlayerState.MOVE:
			process_move(delta)
		PlayerState.ATTACK:
			process_attack(delta)
		PlayerState.ROLL:
			process_roll(delta)


func process_move(delta: float):
	var direction: Vector2
	
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	
	if direction:
		direction = direction.normalized()
		velocity.x = move_toward(velocity.x, direction.x * speed, speed * acceleration * delta / inertia)
		velocity.y = move_toward(velocity.y, direction.y * speed, speed * acceleration * delta / inertia)
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Walk/blend_position", direction)
		animation_tree.set("parameters/Attack/blend_position", direction)
		animation_tree.set("parameters/Roll/blend_position", direction)
		roll_vector = direction
		animation_state.travel("Walk")
		attack_hitbox.attack_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed * friction * delta / inertia)
		velocity.y = move_toward(velocity.y, 0, speed * friction * delta / inertia)
		animation_state.travel("Idle")
	
	move_and_slide()
	
	if Input.is_action_just_pressed("click"):
		player_state = PlayerState.ATTACK
	if Input.is_action_just_pressed("right_click"):
		player_state = PlayerState.ROLL


func process_attack(delta: float):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")


func process_roll(delta: float):
	velocity = roll_vector * roll_speed
	move_and_slide()
	animation_state.travel("Roll")


func attack_animation_finished():
	player_state = PlayerState.MOVE


func roll_animation_finished():
	player_state = PlayerState.MOVE


func _on_health_health_drained():
	died.emit()


func _on_invincibility_timer_timeout():
	hurtbox.set_invincibility(false)
	print("not invincible")


func turn_invincible():
	print(hurtbox.invincible)
	hurtbox.set_invincibility(true)
	invincibility_timer.start()
	print("invincible")


func _on_hurtbox_hit():
	if !hurtbox.invincible:
		turn_invincible()
		$EffectSpawner.spawn_effect()
		$BlinkingPlayer.play("blink")
		health_changed.emit(health.health)
