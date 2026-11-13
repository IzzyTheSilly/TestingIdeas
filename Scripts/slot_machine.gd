extends Node2D
class_name SlotMachine


func turn_slot() -> Array[int]:
	var a: int = randi_range(0, 3)
	var b: int = randi_range(0, 3)
	var c: int = randi_range(0, 3)
	var result: Array[int] = [a, b, c]
	return result
