extends CharacterBody2D
class_name Player

@onready var sprite = $AnimatedSprite2D
@onready var light = $PointLight2D
@export var speed = 50

var max_scale = 2.0
var shrink_speed = 0.03 # need to make shrink_speed start low double and increase over time

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	# animations
	if velocity.length() > 0:
		sprite.play("moving")
		if direction.x > 0:
			sprite.flip_h = true
		elif direction.x < 0:
			sprite.flip_h = false
	else:
		sprite.play("static")

func _ready():
	light.scale = Vector2(0.4, 0.4)

func _process(delta): #shrink
	if light.scale.x > 0:
		light.scale -= Vector2(shrink_speed, shrink_speed) * delta
	else:
		game_over()
		
func game_over():
	set_physics_process(false)
	get_parent().get_node("GameOverLayer").visible = true

func boost_light(boost_amount: float = 0.05):
	var new_size = clamp (light.scale.x + boost_amount, 0.0, max_scale)
	light.scale = Vector2(new_size, new_size)

func camera_shake(intensity: float, duration: float):
	var camera = $Camera2D
	var tween = create_tween()
	for i in range(5): 
		tween.tween_property(camera, "offset", Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity)), duration/5)
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.1)
