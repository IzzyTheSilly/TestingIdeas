extends Node2D
class_name TopDownShooter


signal inventory_toggled(state: bool)


@export var gun: BaseGun
@export var bullet: PackedScene
@export var enemy: PackedScene
@export var inventory: Control
@export var tilemap: TileMapLayer

@export var main_camera: Camera2D

@export var amount_to_proceed1: int
@export var amount_to_proceed2: int


func _ready():
	gun.set_properties(bullet, self)


func _process(delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		inventory.visible = !inventory.visible
		
		if inventory.visible:
			inventory_toggled.emit(true)
		else:
			inventory_toggled.emit(false)


func _on_player_died():
	get_tree().reload_current_scene()


func change_tiles_in_range(tilemap: TileMapLayer, start_coords: Vector2i, end_coords: Vector2i, layer: int = 0, atlas_id: int = 0, atlas_coords: Vector2i = Vector2i(-1, -1), alt_tile: int = 0):
	var distance_x: int = end_coords.x - start_coords.x + 1
	var distance_y: int = end_coords.y - start_coords.y + 1
	
	for x_pos in distance_x:
		for y_pos in distance_y:
			tilemap.set_cell(Vector2i(start_coords.x + x_pos, start_coords.y + y_pos), atlas_id, atlas_coords, alt_tile)


func _on_player_score_changed(amount):
	if amount >= amount_to_proceed1:
		change_tiles_in_range(tilemap, Vector2i(60, 0), Vector2i(60, 10))
	if amount >= amount_to_proceed2:
		change_tiles_in_range(tilemap, Vector2i(120, 31), Vector2i(122, 31))


func _on_stage_3_switch_body_entered(body):
	change_tiles_in_range(tilemap, Vector2i(118, 52), Vector2i(119, 52))
