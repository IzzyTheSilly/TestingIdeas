extends Inventory
class_name PlayerInventory


@export var selected_item_image: TextureRect
@export var selected_item_name: RichTextLabel
@export var selected_item_description: RichTextLabel


func update_item_info_ui():
	if !inventory_data.has_slot(currently_selected_slot) or inventory_data.inventory_slots[currently_selected_slot] == null:
		selected_item_image.hide()
		selected_item_name.hide()
		selected_item_description.hide()
	else:
		selected_item_image.show()
		selected_item_name.show()
		selected_item_description.show()
		var selected_slot: InventorySlot = inventory_data.inventory_slots[currently_selected_slot]
		selected_item_image.texture = selected_slot.item_type.item_sprite
		selected_item_name.text = "[center]" + selected_slot.item_type.item_name + "[/center]"
		selected_item_description.text = "[center]" + selected_slot.item_type.item_description + "[/center]"


func on_left_click_release():
	if Input.is_action_pressed("right_click"):
		return
	
	if inventory_data.has_slot(currently_selected_slot):
		inventory_slots[currently_selected_slot].deselect_slot()
	
	if inventory_data.has_slot(currently_hovered_slot):
		currently_selected_slot = currently_hovered_slot
		inventory_slots[currently_selected_slot].select_slot()
	else:
		currently_selected_slot = -1
	
	if grabbed_slot_data:
		if inventory_data.has_slot(currently_hovered_slot) and inventory_data.has_slot(prev_pos_of_dragged_item):
			if !inventory_data.try_add_item_type(currently_hovered_slot, grabbed_slot_data.item_type, grabbed_slot_data.item_amount):
				inventory_data.replace_item(prev_pos_of_dragged_item, inventory_data.inventory_slots[currently_hovered_slot])
				inventory_data.replace_item(currently_hovered_slot, grabbed_slot_data)
		else:
			inventory_data.try_add_item_type(prev_pos_of_dragged_item, grabbed_slot_data.item_type, grabbed_slot_data.item_amount)
	
	grabbed_slot_display.hide()
	grabbed_slot_data = null
	
	update_item_info_ui()


func _on_texture_button_button_up():
	if !inventory_data.has_slot(currently_selected_slot):
		return
	var thing: GDScript = inventory_data.inventory_slots[currently_selected_slot].item_type.function.new()
	if thing.has_method('item_function'):
		thing.call('item_function')
