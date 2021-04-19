extends Node2D


export (Array, Vector2) var spawn_positions
export (PackedScene) var number_scene
export (float) var spawn_frequency = 1.0
export var number_speed = 200
export var max_number = 100
export var min_number = 1
onready var timer = $Timer
var row

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	row = 0
	if spawn_positions.size() > 0 and number_scene != null:
		timer.wait_time = spawn_frequency
		timer.start()
		

func change_spawn_frequency(new_frequence):
	spawn_frequency = new_frequence
	timer.wait_time = spawn_frequency


func get_random_number():
	return (randi() % max_number + min_number)

func get_correct_number():
	var divisible = get_random_number()
	while divisible % 7 != 0:
		divisible = get_random_number()
	return divisible

func get_wrong_number():
	var not_divisible = get_random_number()
	while not_divisible % 7 == 0:
		not_divisible = get_random_number()
	return not_divisible

func spawn():
	var numbers = []
	numbers.append(get_correct_number())
	numbers.append(get_wrong_number())
	numbers.append(get_wrong_number())
	numbers.shuffle()
	for pos in spawn_positions:
		var child = number_scene.instance()
		get_parent().add_child(child)
		child.position = pos	
		child.value = numbers.pop_back()
		child.speed = number_speed
		child.add_to_group("row" + str(row))
	row += 1


func _on_Timer_timeout():
	spawn()
