extends KinematicBody2D

const SPEED = 400
const SLOW_MOD = 0.5

var velocity = Vector2(0,0)

onready var global = get_node("/root/Global")
var bullet = preload("Bullet.tscn")
onready var battle_scene = get_parent()
onready var anim = get_node("anim")
onready var body = get_node("body")

var invincible = false
var dead = false
var death_timer
var invincible_timer

var screen_clear = preload("ScreenClear.tscn")

func _ready():
	global.player = self
	set_process(true)
	
	death_timer = Timer.new()
	death_timer.set_wait_time(0.7)
	death_timer.connect("timeout",self,"respawn")
	death_timer.set_one_shot(true)
	add_child(death_timer)
	invincible_timer = Timer.new()
	invincible_timer.set_wait_time(2)
	invincible_timer.connect("timeout",self,"stop_invincible")
	invincible_timer.set_one_shot(true)
	add_child(invincible_timer)
			
func _process(delta):
	if !dead:
		velocity = Vector2(0,0)
		if Input.is_action_pressed("move_left"):
			body.set_frame(1)
			velocity.x = -SPEED
		elif Input.is_action_pressed("move_right"):
			body.set_frame(0)
			velocity.x = SPEED
		if Input.is_action_pressed("move_down"):
			body.set_frame(2)
			velocity.y = SPEED
		elif Input.is_action_pressed("move_up"):
			body.set_frame(3)
			velocity.y = -SPEED
			
		if Input.is_action_pressed("move_slow"):
			velocity *= SLOW_MOD
		
		if(position.x < 0):
			position = (Vector2(0,position.y))
		if(position.x > global.WIDTH):
			position = (Vector2(global.WIDTH,position.y))
		if(position.y < 0):
			position = (Vector2(position.x,0))
		if(position.y > global.HEIGHT):
			position = (Vector2(position.x,global.HEIGHT))
		
	move_and_collide(velocity * delta)
	
func _input(event):
	if event.is_action_pressed("special"):
		invincible = true
		invincible_timer.start()
		anim.play("screen_clear")
		get_parent().add_child(screen_clear.instance())
		
func hit():
	if(invincible):
		return
	get_tree().call_group("pattern","reset")
	invincible = true
	dead = true
	velocity = Vector2(0,-300)
	death_timer.start()
	anim.play("invincible")
	print("hit")
	position = (Vector2(global.WIDTH / 2,global.HEIGHT + 50))
	

func _on_BulletTimer_timeout():
	if dead:
		return
	var b = bullet.instance()
	b.position = (position)
	battle_scene.add_child(b)

func respawn():
	dead = false
	invincible_timer.start()
	
func stop_invincible():
	invincible = false
	anim.play("normal")
