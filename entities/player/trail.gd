extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	tween.tween_callback(queue_free)
