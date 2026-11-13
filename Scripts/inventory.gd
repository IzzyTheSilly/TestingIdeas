extends Control
class_name Inventory


signal on_inventory_hovered(inventory: Inventory)
signal on_inventory_unhovered(inventory: Inventory)


@export var inventory_data: InventoryData
@export var item_grid: GridContainer
@export var item_slot_template: PackedScene
var item_scroll: ScrollContainer
@export var grabbed_slot_display: PlayerInventorySlot
var connector: ConnectedInventory
@export var scroll_area: Control

@export_group("Debug")
@export var item_type: ItemTemplate
@export var add_amount: int = 1
@export var switch_slot_1: int = 1
@export var switch_slot_2: int = 2
@export_group("")

var inventory_slots: Array[PlayerInventorySlot]

var prev_pos_of_dragged_item: int = -1
var currently_selected_slot: int = -1
var currently_hovered_slot: int = -1
var grabbed_slot_data: InventorySlot
var scroll_area_hovered: bool = false

var drag_offset: Vector2


func _ready():
	inventory_data.init()
	
	for place in inventory_data.inventory_size:
		var slot: PlayerInventorySlot = item_slot_template.instantiate()
		item_grid.add_child(slot)
		slot.set_item_image(null)
		slot.set_item_amount(null)
		slot.hover_slot.connect(on_hover_slot)
		inventory_slots.append(slot)
	
	update_inventory_ui(inventory_data.inventory_slots)
	inventory_data.on_inventory_changed.connect(update_inventory_ui)
	
	item_scroll = item_grid.get_parent()
	scroll_area.mouse_entered.connect(_on_scroll_area_hovered)
	scroll_area.mouse_exited.connect(_on_scroll_area_unhovered)


func _physics_process(delta):
	if grabbed_slot_display.visible:
		grabbed_slot_display.global_position = get_global_mouse_position() - drag_offset


func update_inventory_ui(inventory: Array[InventorySlot]):
	for place in inventory.size():
		var player_slot: PlayerInventorySlot = inventory_slots[place]
		var slot: InventorySlot = inventory_data.inventory_slots[place]
		
		if slot:
			player_slot.set_item_image(slot.item_type.item_sprite)
			player_slot.set_item_amount(str(slot.item_amount))
		else:
			player_slot.set_item_image(null)
			player_slot.set_item_amount(null)


func update_grabbed_slot_display():
	grabbed_slot_display.set_item_amount(str(grabbed_slot_data.item_amount))
	grabbed_slot_display.set_item_image(grabbed_slot_data.item_type.item_sprite)


func on_left_click_press():
	if Input.is_action_pressed("right_click") or grabbed_slot_data:
		return
	
	prev_pos_of_dragged_item = currently_hovered_slot
	
	if inventory_data.inventory_slots[currently_hovered_slot]:
		grabbed_slot_display.show()
		var hovered_slot: InventorySlot = inventory_data.inventory_slots[currently_hovered_slot]
		grabbed_slot_data = hovered_slot
		update_grabbed_slot_display()
		initialize_drag()
		inventory_data.remove_item(currently_hovered_slot)


func on_left_click_release():
	if Input.is_action_pressed("right_click"):
		return
	
	if !connector.is_on_another_inventory() and grabbed_slot_data:
		if inventory_data.has_slot(currently_hovered_slot):
			if !inventory_data.try_add_item_type(currently_hovered_slot, grabbed_slot_data.item_type, grabbed_slot_data.item_amount):
				inventory_data.replace_item(prev_pos_of_dragged_item, inventory_data.inventory_slots[currently_hovered_slot])
				inventory_data.replace_item(currently_hovered_slot, grabbed_slot_data)
		else:
			inventory_data.try_add_item_type(prev_pos_of_dragged_item, grabbed_slot_data.item_type, grabbed_slot_data.item_amount)
	
	grabbed_slot_display.hide()
	grabbed_slot_data = null


func on_right_click_press():
	if Input.is_action_pressed("click") or grabbed_slot_data:
		return
	
	prev_pos_of_dragged_item = currently_hovered_slot
	
	var hovered_slot: InventorySlot = inventory_data.inventory_slots[currently_hovered_slot]
	if hovered_slot:
		grabbed_slot_data = InventorySlot.new(hovered_slot.item_type, 1)
		update_grabbed_slot_display()
		initialize_drag()
		grabbed_slot_display.show()
		inventory_data.remove_item_amount(currently_hovered_slot, 1)
	else:
		grabbed_slot_display.hide()
		grabbed_slot_data = null


func on_right_click_release():
	if Input.is_action_pressed("click"):
		return
	
	on_left_click_release()


func initialize_drag():
	drag_offset = get_global_mouse_position() - item_grid.get_child(currently_hovered_slot).global_position
	grabbed_slot_display.global_position = get_global_mouse_position() - drag_offset


func on_hover_slot(slot: int):
	currently_hovered_slot = slot
	if inventory_data.has_slot(slot):
		on_inventory_hovered.emit(self)
	else:
		on_inventory_unhovered.emit(self)


func _on_scroll_area_hovered():
	scroll_area_hovered = true


func _on_scroll_area_unhovered():
	scroll_area_hovered = false


func is_scroll_area_hovered() -> bool:
	return scroll_area_hovered or inventory_data.has_slot(currently_hovered_slot)


func _process(delta):
	if Input.is_action_just_pressed("test_add_item"):
		inventory_data.try_add_item_type_carry(currently_selected_slot, item_type, add_amount)
	if Input.is_action_just_pressed("test_switch_item"):
		inventory_data.switch_items(switch_slot_1, switch_slot_2)
	if Input.is_action_just_released("click"):
		on_left_click_release()
	if Input.is_action_just_pressed("click"):
		on_left_click_press()
	if Input.is_action_just_released("right_click"):
		on_right_click_release()
	if Input.is_action_just_pressed("right_click"):
		on_right_click_press()
	if Input.is_action_just_pressed("scroll_down") and visible and is_scroll_area_hovered():
		item_scroll.scroll_vertical += item_scroll.scroll_vertical_custom_step * 2
	if Input.is_action_just_pressed("scroll_up") and visible and is_scroll_area_hovered():
		item_scroll.scroll_vertical -= item_scroll.scroll_vertical_custom_step * 2
	if Input.is_action_pressed("up") and visible and is_scroll_area_hovered():
		item_scroll.scroll_vertical -= item_scroll.scroll_vertical_custom_step
	if Input.is_action_pressed("down") and visible and is_scroll_area_hovered():
		item_scroll.scroll_vertical += item_scroll.scroll_vertical_custom_step
