extends Area2D
class_name PlayerDetector


var player: CharacterBody2D


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	player = body


func _on_body_exited(body):
	player = null


func can_see_player() -> bool:
	return player != null
