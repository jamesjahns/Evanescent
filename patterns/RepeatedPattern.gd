extends "Pattern.gd"

var repeat_timer
var repeat_amount = 0
export var amount_repeated = 3
export var repeat_delay = 0.1

func _ready():
	repeat_timer = Timer.new()
	repeat_timer.connect("timeout",self,"on_timeout")
	repeat_timer.set_one_shot(false)
	repeat_timer.set_wait_time(repeat_delay)
	add_child(repeat_timer)
	
	
func make_pattern():
	if repeat_timer == null:
		return
	repeat_amount = amount_repeated
	repeat_timer.start()

func start_repeated_pattern(amount,delay):
	amount_repeated = amount
	repeat_timer.set_wait_time(delay)

func make_repeated_pattern():
	pass

func on_timeout():
	make_repeated_pattern()
	repeat_amount -= 1
	if (repeat_amount <= 0):
		repeat_timer.stop()