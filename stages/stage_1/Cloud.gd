extends Node2D

var speed = Vector2(70,0) 
onready var global = get_node("/root/Global")

func _ready():
	get_node("cloud"+str(randi() % 3)).set_visible(true)
	set_scale(Vector2(0.7,0.7) * (randf() * 0.5 + 0.75))
	speed *= (randf() * 0.5 + 0.75)
	
func _process(delta):
	translate(delta * speed)
	if position.x > global.WIDTH:
		queue_free()