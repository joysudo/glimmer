extends Area2D

var bend_speed = 0.1
var back_speed = 2.0
var max_skew = 0.2

var active_tween: Tween

func _ready() -> void:
	self.body_entered.connect(_on_grass_body_entered)

func _on_grass_body_entered(body: Node2D) -> void:
	if body is Player:
		if active_tween and active_tween.is_running():
			active_tween.kill()
		var direction = sign(global_position.x - body.global_position.x)
		var target_skew = -direction * max_skew
		active_tween = create_tween()
		active_tween.tween_property($Sprite2D, "skew", target_skew, bend_speed)\
			.set_trans(Tween.TRANS_CUBIC)\
			.set_ease(Tween.EASE_OUT)
		# return animation (queued automatically i think)
		active_tween.tween_property($Sprite2D, "skew", 0.0, back_speed)\
			.set_trans(Tween.TRANS_ELASTIC)\
			.set_ease(Tween.EASE_OUT)
		
