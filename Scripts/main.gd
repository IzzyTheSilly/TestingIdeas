extends Node2D
class_name Main


@export var boubucks_label: RichTextLabel
@export var aubrey: TextureRect
@export var aubrey_sprites: Array[Texture2D]
@export var aubrey_reaction_time: float
@export var kel_interaction_label: RichTextLabel
@export var bouba_audio_player: AudioStreamPlayer2D
@export var jump_audio_player: AudioStreamPlayer2D
@export var dash_audio_player: AudioStreamPlayer2D


func _ready() -> void:
	Engine.time_scale = 1
	update_bouba_text()


func _process(delta) -> void:
	if Input.is_action_just_pressed("restart_scene"):
		get_tree().reload_current_scene() 


func _on_player_died() -> void:
	get_tree().reload_current_scene()


func _on_health_health_drained() -> void:
	pass


func _on_quit_game_area_body_entered(body) -> void:
	get_tree().quit()


func on_get_bouba() -> void:
	GlobalStats.boubucks += 1
	update_bouba_text()
	bouba_audio_player.play()


func update_bouba_text() -> void:
	boubucks_label.text = "Boubucks: " + str(GlobalStats.boubucks)


func aubrey_reaction(sprite_index: int) -> void:
	aubrey.texture = aubrey_sprites[sprite_index]
	await get_tree().create_timer(aubrey_reaction_time).timeout
	aubrey.texture = aubrey_sprites[0]


func _on_player_collect_boubucks() -> void:
	aubrey_reaction(1)


func _on_player_take_damage() -> void:
	aubrey_reaction(3)


func _on_player_give_kel_money() -> void:
	aubrey_reaction(2)
	update_bouba_text()
	kel_interaction_label.text = "GREAT Job gang"


func _on_kel_interaction_area_area_entered(area: Area2D) -> void:
	kel_interaction_label.text = "Press I to give KEL your money!!"
	kel_interaction_label.show()


func _on_kel_interaction_area_area_exited(area: Area2D) -> void:
	kel_interaction_label.hide()


func _on_player_give_kel_not_enough_money() -> void:
	kel_interaction_label.text = "NOT ENOUGH MONEY!!, 15 at LEAST"


func _on_player_jumped() -> void:
	jump_audio_player.play()


func _on_player_dashed() -> void:
	dash_audio_player.play()
