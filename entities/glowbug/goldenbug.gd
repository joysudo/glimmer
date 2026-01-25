extends "res://entities/glowbug/glowbug.gd"

func catch_bug():
	print("golden bug caught! yayay")
	var player = get_tree().current_scene.find_child("player", true, false)
	print(player)
	if player:
		player.boost_light(0.1)
		player.camera_shake(1.0, 0.2)
	bug_caught.emit()
	queue_free()
