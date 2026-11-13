extends RichTextLabel


func _on_player_score_changed(amount):
	GlobalStats.boubucks += 1
	text = "Score: " + str(amount)
