extends Node2D

export var length = 1.0
var timer
var boss
onready var parent = get_parent()
onready var global = get_node("/root/Global")

func _ready():
	get_tree().call_group("pattern","destroy")
	timer = Timer.new()
	timer.set_wait_time(length)
	timer.connect("timeout",self,"on_timeout")
	timer.set_one_shot(true)
	add_child(timer)
	timer.start()

func on_timeout():
	boss.load_attack()
	queue_free()