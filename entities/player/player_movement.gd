extends CharacterBody2D


@export var speed = 200

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
