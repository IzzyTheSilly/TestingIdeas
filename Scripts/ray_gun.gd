extends Node2D
class_name RayGun


var raycast_startpos: Vector2
var raycast_endpos: Vector2
@export var lines: Array[Line2D]
@export var bounce_limit: int
@export var ray_range: int
var player: CharacterBody2D

var hitpoint: Vector2
var normal: Vector2


func _ready() -> void:
	if get_parent() is CharacterBody2D:
		player = get_parent()
	
	lines.resize(bounce_limit + 1)
	for i in bounce_limit + 1:
		var new_line: Line2D = Line2D.new()
		new_line.add_point(Vector2.ZERO)
		new_line.add_point(Vector2.ZERO)
		new_line.width = 1
		add_child(new_line)
		lines[i] = new_line


func _physics_process(delta: float) -> void:
	raycast_startpos = Vector2.ZERO
	var in_vector: Vector2 = get_local_mouse_position().normalized()
	raycast_endpos = in_vector * ray_range
	
	var normal_vector: Vector2
	var reflect_vector: Vector2
	var collision_point: Vector2
	
	for i in bounce_limit:
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(raycast_startpos + global_position, raycast_endpos + global_position)
		query.exclude = [self, player]
		var result = space_state.intersect_ray(query)
		
		lines[i].set_point_position(0, raycast_startpos)
		
		if result:
			print("hit at: " + str(result.position))
			
			in_vector = raycast_endpos - raycast_startpos
			normal_vector = result.normal.normalized()
			reflect_vector = in_vector.reflect(normal_vector)
			collision_point = result.position
			
			raycast_startpos = collision_point - global_position
			raycast_endpos = collision_point - reflect_vector*ray_range - global_position
			lines[i].set_point_position(1, raycast_startpos)
			lines[i].show()
		else:
			lines[i].set_point_position(1, raycast_endpos)
			lines[i+1].hide()
