extends CanvasLayer


onready var animation = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.modulate = "00ffffff"
	animation.play_backwards("fade_out")


func _on_PlayButton_pressed():
	animation.play("fade_out")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_BackButton_pressed():
	animation.play("fade_out")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_TutorialButton_pressed():
	animation.play("fade_out")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://scenes/TutorialEndlessModeMenu.tscn")
