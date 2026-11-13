extends TextureButton


signal changed_hovered(state: bool)
signal mouse_released

@export var reset_position_on_release: bool = false
@export var is_draggable: bool = true

var is_dragging: bool = false
var initial_position: Vector2
var offset: Vector2


func _on_mouse_entered():
	changed_hovered.emit(true)


func _on_mouse_exited():
	changed_hovered.emit(false)


func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() - offset
	
	if Input.is_action_just_released("click"):
		if is_dragging:
			is_dragging = false
			z_index = 0
			mouse_filter = Control.MOUSE_FILTER_STOP
			if reset_position_on_release:
				global_position = initial_position


func _on_button_down():
	if !is_draggable:
		return
	
	is_dragging = true
	z_index = 1
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	initial_position = global_position
	
	offset = get_global_mouse_position() - global_position
