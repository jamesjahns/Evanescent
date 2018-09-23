extends "res://patterns/PathPattern.gd"

onready var width = global.WIDTH * 0.5 - 14

var time = 0.0
var SPEED = 60

func path(t):
	return Vector2(sin(t*2*PI-time) * width ,0)

func time_slow(t):
	return t * 0.2

func make_pattern():
	var b = PathBullet.new()
	b.center = global.from_relative_pos(Vector2(0.5,0))
	b.velocity = Vector2(0,1) * SPEED
	bullets.append(b)
	

func _process_with_slow(delta):
	time += delta
	if(time > 2 * PI):
		time -= 2 * PI