extends Node2D


@onready var _map = $TileMap
var min_x = 0
var min_y = 0
var max_x = 10
var max_y = 10

var max_border = 100

var prev_coord = null

func _process(_delta):
	var mouse_pos = _map.local_to_map(get_global_mouse_position())
	
	_map.set_cell(0, mouse_pos, 0, Vector2(1,0))
	if prev_coord != null and prev_coord != mouse_pos:
		_map.set_cell(0, prev_coord, 0, Vector2(0,0))
	
	prev_coord = mouse_pos
