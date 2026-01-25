extends CharacterBody2D
class_name Player

# essential things
@onready var sprite = $AnimatedSprite2D
@onready var light = $PointLight2D
var speed = 50
var normal_speed = 50
var super_speed = 75
var max_scale = 2.0
var shrink_speed = 0.03 # need to make shrink_speed start low double and increase over time
# trail things
var is_boosted = false
@export var trail_scene: PackedScene
@onready var trail_timer = Timer.new()


func _ready():
	light.scale = Vector2(0.4, 0.4)
	add_child(trail_timer)
	trail_timer.wait_time = 0.05
	trail_timer.timeout.connect(spawn_ghost)

func _physics_process(_delta):
	var current_speed = super_speed if is_boosted else normal_speed
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * current_speed
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

func start_boost():
	is_boosted = true
	trail_timer.start()
	await get_tree().create_timer(3.0).timeout
	is_boosted = false
	trail_timer.stop()
	
func spawn_ghost():
	if velocity.length() > 0:
		var ghost = trail_scene.instantiate()
		get_parent().add_child(ghost)
		ghost.position = position
		ghost.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
		ghost.flip_h = sprite.flip_h
		ghost.scale = sprite.scale

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
	create_tween().tween_property(light, "scale", Vector2(new_size, new_size), 0.3)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func camera_shake(intensity: float, duration: float):
	var camera = $Camera2D
	var tween = create_tween()
	for i in range(5): 
		tween.tween_property(camera, "offset", Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity)), duration/5)
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.1)
