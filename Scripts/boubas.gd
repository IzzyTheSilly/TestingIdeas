extends Node2D
class_name Boubas


var main: Main


func _ready() -> void:
	main = get_parent().get_parent()
	for child in get_children():
		if child is Bouba:
			child.get_this_item.connect(main.on_get_bouba)
