extends "res://patterns/Pattern.gd"

const SPEED = 80

func make_pattern():
	var x = urandf() * global.WIDTH
	var b = newBullet()
	b.pos.x = x
	b.pos.y = global.HEIGHT + 7
	b.velocity = Vector2(0,-1).rotated(0.5*(randf() - 0.5)) * SPEED * (randf()*0.5+0.75)
	bullets.append(b)