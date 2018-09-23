extends "../Boss.gd"

onready var animation = get_node("anim")
var baby_dragons = [null,null,null,null]

func _ready():
	get_node("music").play()
	
func get_attacks():
	return [preload("SlowingTutPattern.tscn"),
			preload("EntryPattern.tscn"),
			preload("SnakingPattern.tscn"),
			preload("../../Generic/NoPattern.tscn"),
			preload("../../Generic/NoPattern.tscn"),
			preload("RainPattern.tscn"),
			preload("../../Generic/NoPattern.tscn"),
			preload("FirebreathingPattern.tscn"),
			preload("TentaclePattern.tscn"),
			preload("WalledBeamPattern.tscn")
			]

func get_health():
	return [200,200,200,200,200,200,200,200,200,200,200]

func get_anim():
	return [preload("anims/EntryAnim.tscn"),
			preload("anims/GenericAnim.tscn"),
			preload("anims/GrowTentaclesAnim.tscn"),
			preload("anims/SpawnBabyDragonsAnim.tscn"),
			preload("anims/BabyDragons2Anim.tscn"),
			preload("anims/BabyDragons3Anim.tscn"),
			preload("anims/BabyDragons4Anim.tscn"),
			preload("anims/RemoveBabiesAnim.tscn"),
			preload("anims/GenericAnim.tscn"),
			preload("anims/FinalAttackAnim.tscn"),
			preload("anims/DeathAnim.tscn")
			]
