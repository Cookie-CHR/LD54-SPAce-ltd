extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.name == "Play":
			child.connect("pressed", play)
		if child.name == "Credits":
			child.connect("pressed", credits)
		if child.name == "Menu":
			child.connect("pressed", menu)
		if child.name == "Map":
			child.connect("pressed", map)
		if child.name == "Mute":
			child.connect("pressed", mute_unmute.bind(child))
		if child.name.is_valid_int():
			child.connect("pressed", to_level.bind(child.name))


func play():
	LevelManager._go_to_level(1)

func credits():
	LevelManager._go_to_credits()
	
func menu():
	LevelManager._go_to_menu()

func map():
	LevelManager._go_to_map()

func to_level(x):
	LevelManager._go_to_level(int(str(x)))

func mute_unmute(child):
	
	if Muter.get_mute():
		child.icon = (load("res://Images/sound_on.png"))
	else:
		child.icon = (load("res://Images/sound_off.png"))
	Muter.mute_unmute()
