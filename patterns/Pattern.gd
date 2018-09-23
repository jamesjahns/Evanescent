extends Node2D

const PLAYER_RADIUS = 4
const BULLET_SLOW_AMT = 0.5

var bullets = []

onready var parent = get_parent()
export var shoot_interval = 1.0
export var interval_randomness = 0.0
export var shoot_delay = 0.0
export var slow_affects_shot_rate = true

export var sped_up_length = 0.0

const bullet_centers = [Vector2(10,10), Vector2(10,10)]
export var bullet_radius = 7
const bullet_colors = [Color(1,0,0), Color(0,0,1)]
const bc_temp = [Color(0.1,0.1,0.1),Color(0.9,0.9,0.9)]
const FUDGE = 200
onready var global = get_node("/root/Global")

var start_shooting_timer = 0
var pattern_timer = 0
var shooting_pattern = false

enum BULLET_SHADE {
	LIGHT,
	DARK
}

export(Color, RGB) var color
export(int, "light", "dark") var shade = 0

var c075
var c05
var c025

class Bullet:
	var pos = Vector2()
	var velocity = Vector2()
	var accel = Vector2()
	var angle = 0.0
	var index = 0


	
func newBullet():
	var b = Bullet.new()
	b.pos = parent.position
	return b
	
func _ready():	
	if shade == BULLET_SHADE.LIGHT:
		c075 = Color(0.9,0.9,0.9,0.75)
		c05 = Color(0.9,0.9,0.9,0.5)
		c025 = Color(0.9,0.9,0.9,0.25)
	else:
		c075 = Color(0.1,0.1,0.1,0.75)
		c05 = Color(0.1,0.1,0.1,0.5)
		c025 = Color(0.1,0.1,0.1,0.25)
	add_to_group("pattern")
	set_process(true)
	if shoot_interval < 0:
		return
	if shoot_delay > 0:
		start_shooting_timer = shoot_delay
	else:
		begin_shooting()
	

func begin_shooting():
	shooting_pattern = true
	make_pattern()
	pattern_timer = shoot_interval

func move_bullet(bullet,delta):
	bullet.pos += bullet.velocity * delta
	bullet.velocity += bullet.accel * delta

func make_pattern():
	pass

func rel_pos(bullet):
	return bullet.pos - parent.position
	
func true_pos(bullet):
	return bullet.pos
	
func _process(delta):	
	if sped_up_length > 0.0:
		sped_up_length -= delta
		delta *= 3
		
	if shoot_interval >= 0 and !slow_affects_shot_rate:
			pattern_timer -= delta * (1 - interval_randomness * (randf() - 0.5))
			
	if sped_up_length <= 0.0 and ((global.slow_light and shade == BULLET_SHADE.LIGHT) or (global.slow_dark and shade == BULLET_SHADE.DARK)):
		delta *= BULLET_SLOW_AMT
	
	
	if start_shooting_timer > 0:
		start_shooting_timer -= delta
		if start_shooting_timer <= 0:
			begin_shooting()
	if shoot_interval >= 0 and slow_affects_shot_rate:
			pattern_timer -= delta * (1 - interval_randomness * (randf() - 0.5))
			
	if shooting_pattern and pattern_timer < 0:
		make_pattern()
		pattern_timer += shoot_interval
		
	_process_with_slow(delta)
	for b in bullets:
		move_bullet(b,delta)
		check_collision(b)
		check_outofbounds(b)
	update()

func _process_with_slow(delta):
	pass
	
func hit_player():
	global.player.hit()

func check_collision(bullet):
	#TODO: delete cheats
	if(global.invincible):
		return
	if(global.player != null):
			if(true_pos(bullet).distance_squared_to(global.player.position) <  (PLAYER_RADIUS + bullet_radius)*(PLAYER_RADIUS + bullet_radius)):
				hit_player()
				
func check_outofbounds(bullet):
	var _pos = true_pos(bullet)
	if(_pos.x < (0-FUDGE) or _pos.x > (global.WIDTH + FUDGE) or _pos.y < (0-FUDGE) or _pos.y > (global.HEIGHT+FUDGE)):
		bullets.erase(bullet)

func draw():
	for b in bullets:
		draw_circle(rel_pos(b), bullet_radius * 1.4, c05)
		draw_circle(rel_pos(b), bullet_radius * 1.2, c025)
		draw_circle(rel_pos(b), bullet_radius, color)
		draw_circle(rel_pos(b), bullet_radius * 0.8, c025)
		draw_circle(rel_pos(b), bullet_radius * 0.6, c025)

#for overwriting reasons
func _draw():
	draw()

func destroy():
	for b in bullets:
		global.add_particle(true_pos(b),color,bullet_radius,true)
	queue_free()

func reset(screen_clear = false):
	for b in bullets:
		global.add_particle(true_pos(b),color,bullet_radius,screen_clear)
	bullets.clear()

func color(b):
	return color

var last_rand = 0.0
func urandf():
	var r = last_rand + randf() * 0.5 + 0.25
	if(r > 1):
		r -= 1
	last_rand = r
	return r
