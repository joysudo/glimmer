extends Node2D

@onready var stats_label = $StatsLabel

func display_stats(combo, time):
	stats_label.text = "Best combo: " + str(combo) + "\nTime: " + str(snapped(time, 0.1)) + " seconds"
	show()
