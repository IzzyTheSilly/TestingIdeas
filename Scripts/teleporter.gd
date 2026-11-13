extends Area2D


@export var scene_to_teleport_to: GlobalScenePaths.scene_paths_enum


func _on_body_entered(body):
	if (body is CharacterBody2D) and GlobalScenePaths.scene_paths.has(GlobalScenePaths.scene_paths_strings[scene_to_teleport_to]):
		get_tree().change_scene_to_file(GlobalScenePaths.scene_paths[GlobalScenePaths.scene_paths_strings[scene_to_teleport_to]])
