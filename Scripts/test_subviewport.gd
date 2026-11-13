extends SubViewport


@export var container: SubViewportContainer
@export var player: Player


func _physics_process(delta):
	container.position = player.position
