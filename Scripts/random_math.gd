extends Node


@export var numbers: Array[int]

@export var interval_amount: int = 11
@export var interval_range: int = 5
@export var interval_start: int = 28


func _ready():
	for interval in interval_amount:
		var numbers_in_interval: int
		for number in numbers:
			
			if number >= interval * interval_range + interval_start and number <= interval * interval_range + interval_start + interval_range - 1:
				numbers_in_interval += 1
		
		print(numbers_in_interval)


func item_function(): # test for item usage mechanic
	print("deez nuts")
