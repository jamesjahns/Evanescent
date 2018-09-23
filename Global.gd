extends Node2D

var player

const WIDTH = 600
const HEIGHT = 750
const STAGE_OFFSET = Vector2(10,10)
const PARTICLE_SPEED = 1100

var energy = 1.0
const ENERGY_LOSS_RATE = 0.38
const ENERGY_GAIN_RATE = 0.25
var slow_light = false
var slow_dark = false

var particles = []

class Particle:
	var pos = Vector2()
	var color = Color()
	var radius = 0
	var follow = true
	var opacity = 0.7

var paused = false

#TODO: delete cheats
const invincible = false

var start_msg = 1

func _ready():
	z_index = 99
	set_process_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)
	set_process(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func _input(event):
	if event.is_action_pressed("slow_light"):
		if (energy > 0 ):
			slow_light = true
			slow_dark = false
	if event.is_action_released("slow_light"):
		slow_light = false

	if event.is_action_pressed("slow_dark"):
		if (energy > 0 ):
			slow_dark = true
			slow_light = false
	if event.is_action_released("slow_dark"):
		slow_dark = false
	
	if event.is_action_pressed("pause"):
		paused = !paused
		get_tree().set_pause(paused)

func _process(delta):
	if (slow_light or slow_dark):
		energy -= ENERGY_LOSS_RATE * delta
		if energy <= 0:
			energy = 0
			slow_light = false
			slow_dark = false
	else:
		energy += ENERGY_GAIN_RATE * delta
	if(energy > 1):
		energy = 1
		
	if(player != null):
		var p_pos = player.global_position
		
		var i = 0
		while(i < particles.size()):
			if particles[i].follow:
				particles[i].pos += (p_pos - particles[i].pos).normalized() * delta * PARTICLE_SPEED
				if particles[i].pos.distance_squared_to(p_pos) < 30:
					particles.remove(i)
				else:
					i += 1
			else:
				particles[i].opacity -= delta * 1
				particles[i].pos += Vector2(0,1) * delta * PARTICLE_SPEED * 0.3
				if particles[i].opacity <= 0:
					particles.remove(i)
				else:
					i += 1
	update()

func from_relative_pos(pos):
	return Vector2(pos.x * WIDTH, pos.y * HEIGHT)

func to_relative_pos(pos):
	return Vector2(pos.x / WIDTH, pos.y / HEIGHT)

func add_particle(pos,color,radius,follow):
	var particle = Particle.new()
	particle.pos = pos + STAGE_OFFSET
	particle.color = color
	particle.radius = radius * 1.2
	particle.follow = follow
	particles.append(particle)

func _draw():
	for p in particles:
		var c = p.color
		c.a = p.opacity
		draw_circle(p.pos,p.radius,c)

	