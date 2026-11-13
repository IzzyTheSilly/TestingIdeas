extends Area2D
class_name Collector


signal amount_collected_changed(amount: int)


var amount_collected: int = 0


func _on_area_entered(area):
	amount_collected += 1
	amount_collected_changed.emit(amount_collected)
