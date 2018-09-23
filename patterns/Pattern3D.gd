extends "./Pattern.gd"
export var max_z = 1
onready var z_scale = 1.0 / (3 * max_z)

#TODO: switch back to textures


class Bullet3D:
	var pos = Vector3()
	var velocity = Vector3()
	var accel = Vector3()
	var index = 0

func true_pos(b):
	return Vector2(b.pos.x,b.pos.y) + position

func check_collision(bullet):
	if(global.player != null):
			if(true_pos(bullet).distance_squared_to(global.player.position) < (PLAYER_RADIUS + bullet_radius[texture] * scale_of(bullet.pos.z))*(PLAYER_RADIUS + bullet_radius[texture] * scale_of(bullet.pos.z))):
				hit_player()

func scale_of(z):
	return  z * z_scale + 1

#TODO: remove square root 
func draw():
	for b in bullets:
		draw_circle(true_pos(b) - position, scale_of(b.pos.z) * bullet_radius[texture]+1, Color(0.9,0.9,0.9))
		draw_circle(true_pos(b) - position, scale_of(b.pos.z) * bullet_radius[texture], bullet_colors[texture])
		