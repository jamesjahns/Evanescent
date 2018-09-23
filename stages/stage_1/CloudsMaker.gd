extends Node2D

var cloud = preload("Cloud.tscn")


func _on_Timer_timeout():
	var rand_y = randf() * 200 + 50
	var c = cloud.instance()
	c.position = Vector2(-100,rand_y)
	add_child(c)
