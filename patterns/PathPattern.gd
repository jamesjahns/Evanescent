extends "Pattern.gd"

export var lifetime_lim = 3.0
export var lasts_forever = false
export var destroy_on_path_end = false

class PathBullet:
	var pos = Vector2()
	var center = Vector2()
	var time = 0
	var velocity = Vector2()
	var accel = Vector2()
	var lifetime = 0

func newBullet():
	var b = PathBullet.new()
	b.center = parent.position
	return b

func path(t):
	return Vector2()

func time_slow(t):
	return t

func move_bullet(bullet,delta):
	bullet.lifetime += delta
	bullet.time += time_slow(delta)
	if bullet.time > 1:
		if destroy_on_path_end:
			bullets.erase(bullet)
			return
		bullet.time -= 1
	bullet.velocity += bullet.accel * delta
	bullet.center += bullet.velocity * delta
	bullet.pos = bullet.center + path(bullet.time)

func precalc_bullets(bullet_num,t_max=1,velocity = Vector2(),accel = Vector2()):
	var step = 1.0 * t_max / (bullet_num-1)
	var t = 0
	for i in range(bullet_num):
		var b = newBullet()
		b.time = t
		b.velocity = velocity
		b.accel = accel
		bullets.append(b)
		t += step

func check_outofbounds(bullet):
	if lasts_forever:
		return
	if(bullet.lifetime > lifetime_lim):
		bullets.erase(bullet)

func reset(screen_clear = false):
	if lasts_forever:
		return
	.reset(screen_clear)