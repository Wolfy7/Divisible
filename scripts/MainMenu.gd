extends CanvasLayer


onready var animation = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.modulate = "00ffffff"
	animation.play_backwards("fade_out")



func _on_CreditsButton_pressed():
	animation.play("fade_out")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://scenes/Credits.tscn")


func _on_EndlessButton_pressed():
	animation.play("fade_out")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://scenes/EndlessMode.tscn")
