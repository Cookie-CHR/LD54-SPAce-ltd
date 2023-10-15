extends Node2D

signal game_success
signal game_fail

var base_scn = preload("res://Components/gameplay.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var level = self.name
	
	var base = base_scn.instantiate()
	base.planets = Diction.planets_lvl[level]
	base.map = Diction.map_lvl[level]
	base.connect("game_success", forward.bind("success"))
	base.connect("game_fail", forward.bind("fail"))
	add_child(base)
	
	$Label.text = Diction.label_lvl[level]

func forward(x):
	if (x=="success"):
		emit_signal("game_success")
	else:
		emit_signal("game_fail")
