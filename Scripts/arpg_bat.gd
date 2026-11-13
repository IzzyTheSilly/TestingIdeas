extends CharacterBody2D


@export var friction: float = 200
@export var acceleration: float = 200
@export var knockback_received: float = 140
@export var move_speed: float = 120
@export var push_force: float = 400

enum BatState {
	IDLE,
	WANDER,
	CHASE,
}
var bat_state: BatState = BatState.IDLE

@export var bat_death_effect: PackedScene

@onready var animated_sprite = $AnimatedSprite2D
@onready var player_detector = $PlayerDetector
@onready var soft_collision = $SoftCollision
@onready var wander_point = $WanderPoint
@onready var animation_player = $BlinkingPlayer


func _physics_process(delta):
	match bat_state:
		BatState.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		BatState.WANDER:
			var wander_direction = global_position.direction_to(wander_point.target_position)
			velocity = velocity.move_toward(wander_direction * move_speed, acceleration * delta)
			print(velocity)
			
			if global_position.distance_to(wander_point.target_position) <= move_speed * delta:
				bat_state = BatState.IDLE
		BatState.CHASE:
			var player: CharacterBody2D = player_detector.player
			if player:
				var direction: Vector2 = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * move_speed, delta * acceleration)
	
	animated_sprite.flip_h = velocity.x < 0
	
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * push_force
	
	move_and_slide()


func _on_hurtbox_area_entered(area):
	$HitEffectSpawner.spawn_effect()
	animation_player.play("blink")
	velocity = area.attack_direction * knockback_received


func _on_health_drained():
	$DeathEffectSpawner.spawn_effect()
	queue_free()


func _on_player_detector_body_entered(body):
	bat_state = BatState.CHASE


func _on_player_detector_body_exited(body):
	bat_state = BatState.IDLE
	wander_point.start()


func pick_random_state(states: Array[BatState]):
	states.shuffle()
	return states.pop_front()


func randomize_wander_timer(lower_limit: float = 0.5, upper_limit: float = 2):
	wander_point.wait_time = randf_range(lower_limit, upper_limit)
	wander_point.start()


func _on_wander_point_timeout():
	match bat_state:
		BatState.IDLE:
			bat_state = BatState.WANDER
			randomize_wander_timer()
		BatState.WANDER:
			bat_state = BatState.IDLE
			randomize_wander_timer()
