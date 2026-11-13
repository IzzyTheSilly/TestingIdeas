extends Object
class_name InventorySlot


var item_type: ItemTemplate
var item_amount: int


func _init(item_type: ItemTemplate, item_amount: int):
	set_item_type(item_type)
	set_item_amount(item_amount)


func set_item_type(item_type: ItemTemplate):
	self.item_type = item_type


func set_item_amount(item_amount: int):
	self.item_amount = item_amount
