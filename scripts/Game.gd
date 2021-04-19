extends Node2D

var score_file = "user://score.save"

var wrong_sound = preload("res://sounds/wrong.ogg")
var correct_sound = preload("res://sounds/correct.ogg")
var level_up_sound = preload("res://sounds/level_up.ogg")
onready var sound_player = $AudioStreamPlayer
onready var bg_music = $BG_Music

onready var pos1 = $Position1
onready var pos2 = $Position2
onready var pos3 = $Position3

onready var player = $Player
onready var pos = 1
onready var positions = [pos1, pos2, pos3]

onready var label_score = $HUD/label_score
onready var label_failed = $HUD/label_failed
onready var gameover_label_score = $HUD/GameOver/TextureRect/gameover_label_score
onready var gameover_highscore_score = $HUD/GameOver/TextureRect/gameover_label_highscore
onready var gameover_postit = $HUD/GameOver
var score = 0
var highscore = 0
var failed = 0
var can_move = true
onready var move_timer = $Timer
var row 

onready var number_particels = $NumberParticles
onready var animation_player = $AnimationPlayer

var current_level = 0
var levels = [
	{"frequence" : 5, "speed" : 200, "max" : 99, "min" : 1},
	{"frequence" : 5, "speed" : 300, "max" : 99, "min" : 1},
	{"frequence" : 4, "speed" : 350, "max" : 99, "min" : 1},
	{"frequence" : 3, "speed" : 300, "max" : 99, "min" : 1},
	{"frequence" : 3, "speed" : 400, "max" : 900, "min" : 100},
	{"frequence" : 2, "speed" : 400, "max" : 900, "min" : 100},
	{"frequence" : 1, "speed" : 500, "max" : 900, "min" : 100}	
]

onready var spawner = $NumberSpawner

func set_level(level):
	#spawner.spawn_frequency = levels[level]["frequence"]
	spawner.change_spawn_frequency(levels[level]["frequence"])
	spawner.number_speed = levels[level]["speed"]
	spawner.max_number = levels[level]["max"]
	spawner.min_number = levels[level]["min"]
	#bg_music.pitch_scale = 1.0 + (level / 10.0)

func save_score():
	var file = File.new()
	file.open(score_file, File.WRITE)
	file.store_var(highscore)
	file.close()
	

func load_score():
	var file = File.new()
	if file.file_exists(score_file):
		file.open(score_file, File.READ)
		highscore = file.get_var()
		file.close()
	else:
		highscore = 0
		
		

func _ready():
	set_level(0)
	animation_player.play_backwards("fade")
	player.position = positions[pos].position
	gameover_postit.visible = false
	score = 0
	label_score.text = "Score: " + str(score)
	gameover_label_score.text = "Score: " + str(score)
	can_move = true
	failed = 0
	label_failed.text = str("")
	load_score()
	row = 0

func _process(_delta):
	
	#$ParallaxBackground.scroll_offset.x -= 100 * delta
	if can_move:
		if Input.is_action_just_pressed("ui_up"):
			pos = max(0, pos-1)			
		if Input.is_action_just_pressed("ui_down"):
			pos = min(2, pos+1)
		
	player.position = positions[pos].position
	
	
func spawn_particle(value, pos):
	if value == 0:
		number_particels.modulate = "37c837"
	else:
		number_particels.modulate = "d40000"
		
	number_particels.position = pos	
	number_particels.process_material.anim_offset = value
	number_particels.emitting = true
	

func _on_Timer_timeout():
	can_move = true

func _on_Player_area_entered(area):
	#print(area.value)
	can_move = false
	move_timer.start()
	
	if (area.value % 7) == 0:
		sound_player.stream = correct_sound
		sound_player.play()
		score += 1
		label_score.text = "Score: " + str(score)
		gameover_label_score.text = "Score: " + str(score)
		spawn_particle((area.value % 7) / 10.0, area.position)
	else:
		sound_player.stream = wrong_sound
		sound_player.play()
		failed += 1
		label_failed.text = str(failed)
		spawn_particle((area.value % 7) / 10.0, area.position)
		if failed == 7:
			if score > highscore:
				highscore = score
				save_score()
			gameover_highscore_score.text = "HighScore: " + str(highscore)
			gameover_postit.visible = true
			move_timer.stop()
			can_move = false
			get_tree().call_group("Number", "queue_free")
			$NumberSpawner/Timer.stop()
	
	area.queue_free()
	get_tree().call_group("row" + str(row), "disable_collision")
	row += 1
	

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_PlayagainButton_pressed():
	get_tree().reload_current_scene()


func _on_Area2D_area_exited(area):
	area.queue_free()


func _on_InfoTimer_timeout():
	animation_player.play("fade")


func _on_LevelTimer_timeout():
	if current_level >= levels.size():
		return
	current_level += 1
	set_level(current_level)
	sound_player.stream = level_up_sound
	sound_player.play()
