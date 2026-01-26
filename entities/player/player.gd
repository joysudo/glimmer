extends CharacterBody2D
class_name Player

# essential things
@onready var sprite = $AnimatedSprite2D
@onready var light = $PointLight2D
var normal_speed = 50
var super_speed = 75
var max_scale = 0.4
var shrink_speed = 0.03 # need to make shrink_speed start low double and increase over time
# trail things
var is_boosted = false
@export var trail_scene: PackedScene
@onready var trail_timer = Timer.new()
# combo things
var combo_count = 0
var combo_timer = 0.0
var combo_window = 2.0
var best_combo = 0

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

func update_combo():
	combo_count += 1
	combo_timer = combo_window
	if combo_count > best_combo:
		best_combo = combo_count
	if combo_count > 1:
		super_speed += 10
		camera_shake(0.5*combo_count, 0.2)
		var label = $"../ComboManager/ComboLabel"
		label.text = "COMBO x" + str(combo_count)
		create_tween().tween_property(label, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_ELASTIC)
		label.scale = Vector2(0.7, 0.7)
		var overlay = $"../CanvasModulate"
		var strength = clamp(0.05* (combo_count-1), 0.0, 0.8)
		overlay.color = overlay.color.lerp(Color.WHITE, strength)

func _process(delta): #shrink
	if light.scale.x > 0:
		light.scale -= Vector2(shrink_speed, shrink_speed) * delta
	else:
		game_over()
	if combo_count > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			reset_combo()

func reset_combo():
	combo_count = 0
	super_speed = 75 # this is lowk a magic number; i should separate this into two variables (super_speed and updated_super_speed?)
	var overlay = $"../CanvasModulate"
	create_tween().tween_property(overlay, "color", Color.html("#00242f"), 1.5).set_trans(Tween.TRANS_SINE)
	var label = $"../ComboManager/ComboLabel"
	label.text = ""


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

func game_over():
	set_physics_process(false)
	set_process(false)
	
	var time_lasted = (Time.get_ticks_msec() - get_parent().start_time) / 1000.0
	get_parent().get_node("GameOverLayer").get_node("Node2D").display_stats(best_combo, time_lasted)
	get_parent().get_node("GameOverLayer").visible = true
