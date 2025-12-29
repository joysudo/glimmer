extends CharacterBody2D

@onready var light = $PointLight2D
@export var speed = 75

var max_scale = 0.5
var shrink_speed = 0.02

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

func _ready():
	light.scale = Vector2(0.4, 0.4)

func _process(delta): #shrink
	if light.scale.x > 0:
		light.scale -= Vector2(shrink_speed, shrink_speed) * delta

func boost_light():
	light.scale = clamp(light.scale + Vector2(0.05, 0.05), 0, max_scale) # change this number if needed
