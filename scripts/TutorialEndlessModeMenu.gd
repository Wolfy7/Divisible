extends CanvasLayer


onready var animation = $AnimationPlayer
onready var back_btn = $Control/BackButton
onready var forward_btn = $Control/ForwardButton
var step = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.modulate = "00ffffff"
	animation.play_backwards("fade_out")
	get_node("Control/Step" + str(step)).visible = true
	back_btn.visible = false
	forward_btn.visible = true


func switch_step(next_step):
	
	if next_step == 5:
		animation.play("fade_out")
		yield(animation, "animation_finished")
		get_tree().change_scene("res://scenes/EndlessMode.tscn")
	else:
		get_node("Control/Step" + str(step)).visible = false
		get_node("Control/Step" + str(next_step)).visible = true
		back_btn.visible = true
		if next_step == 0:
			back_btn.visible = false
		step = next_step
	

func _on_BackButton_pressed():
	switch_step(step - 1)


func _on_ForwardButton_pressed():
	switch_step(step + 1)
