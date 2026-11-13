extends Resource
class_name InventoryData


signal on_inventory_changed(inventory: Array[InventorySlot])


@export var inventory_size: int = 1
var inventory_slots: Array[InventorySlot]
var has_initialized: bool = false


func init():
	if !has_initialized:
		for i in inventory_size:
			inventory_slots.append(null)
		has_initialized = true


func try_add_item(slot: int, item: InventorySlot) -> bool:
	if !has_slot(slot):
		return false
	if inventory_slots[slot]:
		return false
	
	inventory_slots[slot] = item
	on_inventory_changed.emit(inventory_slots)
	return true


func try_add_item_carry(start_slot: int, item: InventorySlot) -> bool:
	for slot in range(start_slot, inventory_slots.size()):
		if try_add_item(slot, item):
			return true
		
	return false


func try_add_item_type(slot: int, item_type: ItemTemplate, add_amount: int) -> bool:
	if !has_slot(slot):
		return false
	if item_type.max_stack < add_amount:
		return false
	
	if inventory_slots[slot] == null:
		var new_slot = InventorySlot.new(item_type, add_amount)
		inventory_slots[slot] = new_slot
		on_inventory_changed.emit(inventory_slots)
		return true
	elif (inventory_slots[slot].item_type == item_type) and (inventory_slots[slot].item_amount + add_amount <= inventory_slots[slot].item_type.max_stack):
		inventory_slots[slot].set_item_amount(inventory_slots[slot].item_amount + add_amount)
		on_inventory_changed.emit(inventory_slots)
		return true
	
	return false


func try_add_item_type_carry(start_slot: int, item_type: ItemTemplate, add_amount: int) -> int:
	for i in add_amount:
		var can_add_item: bool = false
		
		for j in range(start_slot, inventory_slots.size()):
			if try_add_item_type(j, item_type, 1):
				can_add_item = true
				break
		
		if can_add_item == false:
			return add_amount - i
	
	return 0


func remove_item(slot: int):
	inventory_slots[slot] = null
	on_inventory_changed.emit(inventory_slots)


func remove_item_amount(slot: int, amount: int):
	if inventory_slots[slot].item_amount - amount > 0:
		inventory_slots[slot].item_amount -= amount
		on_inventory_changed.emit(inventory_slots)
	else:
		remove_item(slot)


func replace_item(slot: int, item: InventorySlot):
	inventory_slots[slot] = item
	on_inventory_changed.emit(inventory_slots)


func switch_items(slot1: int, slot2: int):
	var item1 = inventory_slots[slot1]
	var item2 = inventory_slots[slot2]
	
	replace_item(slot1, item2)
	replace_item(slot2, item1)


func switch_items_with_other_inventory(inventory: InventoryData, slot1: int, slot2: int):
	var item1 = inventory_slots[slot1]
	var item2 = inventory.inventory_slots[slot2]
	
	replace_item(slot1, item2)
	inventory.replace_item(slot2, item1)


func has_slot(slot: int):
	if slot > -1 and slot < inventory_size:
		return true
	
	return false
