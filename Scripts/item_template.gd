extends Resource
class_name ItemTemplate


@export var item_name: String = "New Item"
@export var item_sprite: Texture2D
@export var max_stack: int = 1
@export_multiline var item_description: String = "Insert description"
@export var function: GDScript
