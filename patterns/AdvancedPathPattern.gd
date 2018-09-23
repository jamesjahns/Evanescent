extends "PathPattern.gd"

class AdvPathBullet:
	var pos = Vector2()
	var center = Vector2()
	var time = 0
	var lifetime = 0

func move_bullet(bullet,delta):
	bullet.lifetime += delta
	bullet.time += time_slow(delta)
	bullet.pos = bullet.center + center_path(bullet.lifetime) + path(bullet)

func precalc_bullets(bullet_num,t_max):
	var step = 1.0 * t_max / bullet_num
	var t = 0
	for i in range(bullet_num):
		var b = newBullet()
		b.time = t
		bullets.append(b)
		t += step

func center_path(t):
	return t
