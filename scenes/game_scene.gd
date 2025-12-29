extends Node2D

@export var bug_scene: PackedScene
@export var map_size = Vector2(160, 144)

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_bug()

func spawn_bug():
	var new_bug = bug_scene.instantiate()
	var random_x = randf_range(-map_size.x/2, map_size.x/2)
	var random_y = randf_range(-map_size.y/2, map_size.y/2)
	new_bug.position = Vector2(random_x, random_y)
	new_bug.bug_caught.connect(spawn_bug)
	add_child(new_bug)
