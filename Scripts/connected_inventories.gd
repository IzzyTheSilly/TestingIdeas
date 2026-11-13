extends Control
class_name ConnectedInventory


@export var connected_inventories: Array[Inventory]

var prev_inventory_of_dragged_item: Inventory
var currently_hovered_inventory: Inventory


func _ready():
	for inventory in connected_inventories:
		inventory.on_inventory_hovered.connect(_on_inventory_hovered)
		inventory.on_inventory_unhovered.connect(_on_inventory_unhovered)
		inventory.connector = self


func _on_inventory_hovered(inventory: Inventory):
	currently_hovered_inventory = inventory


func _on_inventory_unhovered(inventory: Inventory):
	currently_hovered_inventory = null


func on_left_click_press():
	prev_inventory_of_dragged_item = currently_hovered_inventory


func on_left_click_release():
	if is_on_another_inventory() and !currently_hovered_inventory.inventory_data.try_add_item_type(currently_hovered_inventory.currently_hovered_slot, prev_inventory_of_dragged_item.grabbed_slot_data.item_type, prev_inventory_of_dragged_item.grabbed_slot_data.item_amount):
		print("yahoo")
		prev_inventory_of_dragged_item.inventory_data.replace_item(prev_inventory_of_dragged_item.prev_pos_of_dragged_item, currently_hovered_inventory.inventory_data.inventory_slots[currently_hovered_inventory.currently_hovered_slot])
		currently_hovered_inventory.inventory_data.replace_item(currently_hovered_inventory.currently_hovered_slot, prev_inventory_of_dragged_item.grabbed_slot_data)


func on_right_click_press():
	on_left_click_press()


func on_right_click_release():
	on_left_click_release()


func is_on_another_inventory() -> bool:
	return currently_hovered_inventory and prev_inventory_of_dragged_item and prev_inventory_of_dragged_item.grabbed_slot_data and prev_inventory_of_dragged_item != currently_hovered_inventory


func _process(delta):
	if Input.is_action_just_pressed("click"):
		on_left_click_press()
	if Input.is_action_just_released("click"):
		on_left_click_release()
	if Input.is_action_just_pressed("right_click"):
		on_right_click_press()
	if Input.is_action_just_released("right_click"):
		on_right_click_release()
