extends Area2D


var speed = 200 setget set_speed
var value setget set_value

onready var collision_shape = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta
	
func set_speed(new_speed):
	speed = new_speed


func set_value(new_value):
	value = new_value
	var value_text = str(value)
	$Label.text = value_text
	
	var collision_shape = RectangleShape2D.new()
	collision_shape.extents.x = 18 * value_text.length()
	collision_shape.extents.y = 26
	$CollisionShape2D.shape = collision_shape
	$CollisionShape2D.position.x = 18 * value_text.length()


func disable_collision():
	collision_shape.disabled = true
