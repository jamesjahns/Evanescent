extends "res://patterns/Pattern.gd"

export(NodePath) var ball_path
onready var ball = get_node(ball_path)
export var max_speed = 500
export var accel = 1800
var velocity_x = 0
export var num_bullets = 20
export var bullet_speed = 100
onready var body = get_node("body")

func _process_with_slow(delta):
	velocity_x += delta * accel * sign((ball.get_pos()-(body.get_pos() + get_pos())).x)
	if(abs(velocity_x) > max_speed):
		velocity_x = max_speed * sign(velocity_x)
	
	body.move(Vector2(velocity_x,0) * delta)
		
func emit(pos,normal):
	for i in range(num_bullets):
		var b = Bullet.new()
		b.pos = pos - get_global_pos()
		b.velocity = normal.rotated((randf() - 0.5) * 1.5 * PI) * bullet_speed
		bullets.append(b)

func check_outofbounds(bullet):
	var _pos = true_pos(bullet)
	if((_pos.x < 0 and bullet.velocity.x < 0) or (_pos.x > global.WIDTH and bullet.velocity.x > 0)):
		if(bullet.index >= 3):
			bullets.erase(bullet)
		bullet.index += 1
		bullet.velocity.x *= -1
	if((_pos.y < 0 and bullet.velocity.y < 0) or (_pos.y > global.HEIGHT and bullet.velocity.y > 0)):
		if(bullet.index >= 3):
			bullets.erase(bullet)
		bullet.index += 1
		bullet.velocity.y *= -1
		
func draw():
	draw_rect(Rect2(Vector2(-74,-18)+body.get_pos(),Vector2(148,36)),Color(0,0,0))
	draw_rect(Rect2(Vector2(-70,-14)+body.get_pos(),Vector2(140,28)),bullet_colors[texture])
	.draw()