extends Sprite2D


signal get_bouba

var player: Player
var score: int
@export var score_label: RichTextLabel
var is_parked: bool = false


func _ready() -> void:
	player = get_parent()


func _process(delta: float) -> void:
	if !is_parked:
		rotation = deg_to_rad(90 + (player.velocity.x/ 12))


func _on_area_2d_area_entered(area: Area2D) -> void:
	process_hit_obstacle(area)


func _on_area_2d_2_area_entered(area: Area2D) -> void:
	process_hit_obstacle(area)


func process_hit_obstacle(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is SpawnableFallingObstacleBase:
		if parent.is_bouba:
			GlobalStats.boubucks += 1
			score += 1
			score_label.text = "Score: " + str(score)
			get_bouba.emit()


func car_parked() -> void:
	is_parked = true
