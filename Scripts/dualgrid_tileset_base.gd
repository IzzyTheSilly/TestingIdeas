extends TileMapLayer
class_name DualGridTileMapBase


@export var visuals_tilemap: DualGridTileMapVisuals

enum Direction {NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST}


func _ready() -> void:
	visuals_tilemap.base_layer = self


func _process(delta: float) -> void:
	var cell_hovered: Vector2i = local_to_map(get_local_mouse_position())
	
	if Input.is_action_pressed("click"):
		set_cell(cell_hovered, 8, Vector2i(0, 0))
		call_visual_cells(cell_hovered)

	if Input.is_action_pressed("right_click"):
		if get_cell_tile_data(cell_hovered) != null:
			set_cell(cell_hovered, -1)
			call_visual_cells(cell_hovered, false)

func get_neighbors_array(direction: Direction, tile_coords: Vector2i, state: bool) -> Array[int]:
	var neighbors_array: Array[int] = [0,0,0,0]
	var cell_state: int = 1
	if state == false:
		cell_state = 0
	
	match direction:
		Direction.NORTHWEST:
			neighbors_array[3] = cell_state
			if get_cell_tile_data(Vector2i(tile_coords.x - 1, tile_coords.y - 1)) != null:
				neighbors_array[0] = 1
			if get_cell_tile_data(Vector2i(tile_coords.x, tile_coords.y - 1)) != null:
				neighbors_array[1] = 1
			if get_cell_tile_data(Vector2i(tile_coords.x - 1, tile_coords.y)) != null:
				neighbors_array[2] = 1
		Direction.NORTHEAST:
			neighbors_array[2] = cell_state
			if get_cell_tile_data(Vector2i(tile_coords.x, tile_coords.y - 1)) != null:
				neighbors_array[0] = 1
			if get_cell_tile_data(Vector2i(tile_coords.x + 1, tile_coords.y - 1)) != null:
				neighbors_array[1] = 1
			if get_cell_tile_data(Vector2i(tile_coords.x + 1, tile_coords.y)) != null:
				neighbors_array[3] = 1
		Direction.SOUTHWEST:
			neighbors_array[1] = cell_state
			if get_cell_tile_data(Vector2i(tile_coords.x - 1, tile_coords.y)) != null:
				neighbors_array[0] = 1
			if get_cell_tile_data(Vector2i(tile_coords.x - 1, tile_coords.y + 1)) != null:
				neighbors_array[2] = 1
			if get_cell_tile_data(Vector2i(tile_coords.x, tile_coords.y + 1)) != null:
				neighbors_array[3] = 1
		Direction.SOUTHEAST:
			neighbors_array[0] = cell_state
			if get_cell_tile_data(Vector2i(tile_coords.x + 1, tile_coords.y)) != null:
				neighbors_array[1] = 1
			if get_cell_tile_data(Vector2i(tile_coords.x, tile_coords.y + 1)) != null:
				neighbors_array[2] = 1
			if get_cell_tile_data(Vector2i(tile_coords.x + 1, tile_coords.y + 1)) != null:
				neighbors_array[3] = 1
	
	return neighbors_array


func call_visual_cells(cell_hovered: Vector2i, state: bool = true) -> void:
	visuals_tilemap.set_visual_tiles(Vector2i(cell_hovered.x - 1, cell_hovered.y - 1), get_neighbors_array(Direction.NORTHWEST, cell_hovered, state))
	visuals_tilemap.set_visual_tiles(Vector2i(cell_hovered.x, cell_hovered.y - 1), get_neighbors_array(Direction.NORTHEAST, cell_hovered, state))
	visuals_tilemap.set_visual_tiles(Vector2i(cell_hovered.x - 1, cell_hovered.y), get_neighbors_array(Direction.SOUTHWEST, cell_hovered, state))
	visuals_tilemap.set_visual_tiles(Vector2i(cell_hovered), get_neighbors_array(Direction.SOUTHEAST, cell_hovered, state))
