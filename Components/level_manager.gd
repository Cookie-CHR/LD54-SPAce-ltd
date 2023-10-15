extends Control

var level_scn = preload("res://scenes/level.tscn")

func _go_to_level(num):
	get_tree().get_current_scene().queue_free()
	
	var root = get_tree().get_root()  
	
	if(!Diction.planets_lvl.has(str(num))):
		get_tree().change_scene_to_file("res://scenes/victory.tscn")
	else:
		var level = level_scn.instantiate()
		level.name = "Level"
		level.curr_level = num
		root.add_child(level)
		get_tree().set_current_scene(level)
	
func _go_to_credits():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	
func _go_to_menu():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
func _go_to_map():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
	
