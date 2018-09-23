extends "Pattern.gd"

class RadialBullet:
	var pos = Vector2()
	var center = Vector2()
	var velocity = 0
	var angle = 0.0
	var magnitude = 0.0

func newBullet():
	var b = RadialBullet.new()
	b.center = parent.position
	return b

func move_bullet(bullet,delta):
	bullet.magnitude += bullet.velocity * delta
	bullet.pos = bullet.center + bullet.magnitude * Vector2(cos(bullet.angle),sin(bullet.angle))

func check_outofbounds(bullet):
	if (bullet.magnitude > 1100):
		bullets.erase(bullet)