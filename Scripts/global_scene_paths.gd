extends Node


var scene_paths = {
	"Main": "res://Scenes/main.tscn",
	"TopDownShooter": "res://Scenes/top_down_shooter.tscn",
	"TrailOfTorment": "res://Scenes/trail_of_torment.tscn",
	"2DActionRPG": "res://Scenes/2d_action_rpg.tscn",
	"TilemapShenanigans": "res://Scenes/tile_map_shenanigans.tscn",
	"Bergentrucking": "res://Scenes/bergentrucking.tscn",
	"ThePlayground": "res://Scenes/the_playground.tscn",
	"RayGun": "res://Scenes/ray_gun.tscn"
}
enum scene_paths_enum {
	Main,
	TopDownShooter,
	TrailOfTorment,
	TwoDActionRPG,
	TilemapShenanigans,
	Bergentrucking,
	ThePlayground,
	RayGun
}
var scene_paths_strings = scene_paths.keys()
