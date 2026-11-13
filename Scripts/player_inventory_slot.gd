extends TextureRect
class_name PlayerInventorySlot


signal hover_slot(index: int)


@export var item_image: TextureRect
@export var amount_text: RichTextLabel

var is_selected: bool = false
@export var selected_color: Color
@export var hovered_color: Color


func set_item_image(sprite):
	if sprite and sprite is Texture2D:
		item_image.texture = sprite
		item_image.show()
	else:
		item_image.hide()


func set_item_amount(amount):
	if amount and amount is String and amount != "1":
		amount_text.text = amount
		amount_text.show()
	else:
		amount_text.hide()


func select_slot():
	is_selected = true
	self_modulate = selected_color


func deselect_slot():
	is_selected = false
	self_modulate = Color.WHITE


func _on_mouse_entered():
	hover_slot.emit(get_index())
	if !is_selected:
		self_modulate = hovered_color


func _on_mouse_exited():
	hover_slot.emit(-1)
	if !is_selected:
		self_modulate = Color.WHITE
