extends Resource
class_name SpawnableFallingObstacleInfo


##ideally all the probabilities should add up to 100, but whatever number works.
@export var probability: int
@export var sprite: CompressedTexture2D
##Relative to the road.
@export var speed: int
@export var is_bouba: bool
@export var is_baby: bool
@export var is_roadblock: bool
