extends Node2D

var init_pos
var screen_shaking = false

func _ready():
	init_pos = position
	add_to_group("stage")
	
func _process(delta):
	if screen_shaking:
		screen_shake()

func screen_shake():
	position = init_pos + Vector2(6*(randf()-0.5),6*(randf()-0.5))

func start_screen_shake():
	screen_shaking = true

func end_screen_shake():
	print("ues")
	screen_shaking = false
	position = init_pos

func play_anim(a):
	get_node("anim").play(a)