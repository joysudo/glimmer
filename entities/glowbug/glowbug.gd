extends Area2D

signal bug_caught
var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	var sprite = $AnimatedSprite2D
	var original_scale = sprite.scale
	sprite.scale = Vector2.ZERO
	create_tween().tween_property(sprite, "scale", original_scale, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		catch_bug()

func catch_bug():
	print("player caught the bug")
	bug_caught.emit()
	queue_free()
