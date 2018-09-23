extends "../../BossAnimation.gd"

func _ready():
	boss._set_pos(global.from_relative_pos(Vector2(0.5,0.25)))
	boss.animation.play("final_attack")
	get_tree().call_group("game_screen","start_screen_shake")

func on_timeout():
	get_tree().call_group("game_screen","end_screen_shake")
	.on_timeout()
