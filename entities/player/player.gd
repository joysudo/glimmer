extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var light = $PointLight2D
@export var speed = 75

var max_scale = 0.5
var shrink_speed = 0.03 # need to make shrink_speed start low double and increase over time
var boost = 0.05

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

func boost_light():
	var new_size = clamp (light.scale.x + boost, 0.0, max_scale)
	light.scale = Vector2(new_size, new_size)
