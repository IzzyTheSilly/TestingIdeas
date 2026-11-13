@tool
extends Node2D


signal player_in_range
signal player_not_in_range


@export var item_template: ItemTemplate
@export var player_inventory: InventoryData
@export_enum("WhenCollide", "WhenPress") var pickup_mode: int

var pickupable: bool = false


func _ready():
	$Sprite2D.texture = item_template.item_sprite


func _process(delta):
	$Sprite2D.texture = item_template.item_sprite
	
	if !Engine.is_editor_hint():
		if Input.is_action_just_pressed("pick_up_item") and pickup_mode == 1 and pickupable:
			pick_up(player_inventory)

func pick_up(inventory: InventoryData):
	inventory.try_add_item_type_carry(0, item_template, 1)
	queue_free()


func _on_area_2d_body_entered(body):
	if pickup_mode == 0:
		pick_up(player_inventory)


func _on_pickup_area_body_entered(body):
	pickupable = true
	print("in")
	player_in_range.emit()


func _on_pickup_area_body_exited(body):
	pickupable = false
	print("out")
	player_not_in_range.emit()
