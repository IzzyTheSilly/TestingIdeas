extends TileMapLayer
class_name DualGridTileMapVisuals


@export var atlas_id: int

var base_layer: DualGridTileMapBase
var neigbor_array_to_tile_coord = {
	[0,0,0,0]: [0,0],
	[1,0,0,0]: [2,1],
	[0,1,0,0]: [2,0],
	[0,0,1,0]: [2,3],
	[0,0,0,1]: [2,2],
	[1,1,0,0]: [3,3],
	[1,0,1,0]: [3,1],
	[1,0,0,1]: [1,3],
	[0,1,1,0]: [0,3],
	[0,1,0,1]: [3,0],
	[0,0,1,1]: [3,2],
	[1,1,1,0]: [0,1],
	[1,1,0,1]: [1,1],
	[1,0,1,1]: [0,2],
	[0,1,1,1]: [1,2],
	[1,1,1,1]: [0,0]
}


func set_visual_tiles(cell: Vector2i, neighbor_array: Array[int]):
	if neighbor_array == [0,0,0,0]:
		set_cell(cell, -1)
	else:
		set_cell(cell, atlas_id, Vector2i(neigbor_array_to_tile_coord[neighbor_array][0], neigbor_array_to_tile_coord[neighbor_array][1]))
