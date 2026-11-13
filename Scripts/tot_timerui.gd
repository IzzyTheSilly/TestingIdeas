extends RichTextLabel


var time_since_spawn: float = 0


func _ready():
	time_since_spawn = 0


func _process(delta):
	time_since_spawn += delta
	
	text = "Time since at spawn: " + str(round(time_since_spawn * 1000) / 1000)
	
	if Input.is_action_just_pressed("return_to_spawn"):
		time_since_spawn = 0
