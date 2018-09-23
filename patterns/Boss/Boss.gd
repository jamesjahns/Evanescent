extends Area2D

var attack_array = get_attacks()
var health_array = get_health()
var anim_array = get_anim()
var current_health = health_array[0]
var attack_index = 0
var current_attack
var start_pos = Vector2()
var end_pos = Vector2(0,0)
var interp_time = 0
var parent
onready var sound = get_node("sounds")
const SPEED = 300

var invincible = true

export var interp_length = 0.5

func _ready():
	
	connect("area_entered",self,"on_area_enter")
	parent = get_parent()
	call_deferred("next_anim")
	end_pos = position
	add_to_group("boss")
	
	set_process(true)
	
func _process(delta):
	
	if current_health <= 0:
		next_anim()
	
	if(end_pos != position):
		#cosine-based interpolation
		var lerp_val = lerp(0,1,-cos(PI * interp_time / interp_length) * 0.5 + 0.5)
		position = (start_pos * (1-lerp_val) + end_pos * lerp_val)
		interp_time += delta
		if(interp_time > interp_length):
			interp_time = interp_length

func next_anim():
	invincible = true
	current_health = 100
	var anim = anim_array[attack_index].instance()
	anim.boss = self
	parent.add_child(anim)
	
func move_to(pos):
	start_pos = position
	end_pos = pos
	interp_time = 0

func _set_pos(pos):
	position = (pos)
	end_pos = pos

func load_attack():
	if(attack_index >= attack_array.size()):
			die()
			return
	invincible = false
	current_attack = attack_array[attack_index].instance()
	if current_attack.has_method("set_boss"):
		current_attack.set_boss(self)
	current_attack.position = position
	parent.add_child(current_attack)
	current_health = health_array[attack_index]
	get_tree().call_group("boss_health","set_max",current_health)
	
	attack_index += 1

func get_attack():
	return []

func get_health():
	return [0]

func get_anim():
	return []

func _input(event):
	if event.is_action_pressed("cheat"):
		current_health -= 9999999
		get_tree().call_group("boss_health","set_health",current_health)
		
func die():
	print("ded")

func on_area_enter(area):
	if invincible:
		return
	if area.get("IS_BULLET"):
		sound.play()
		current_health -= 1
		get_tree().call_group("boss_health","set_health",current_health)
	

