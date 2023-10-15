extends TileMap

var max_pos = {"x": 10, "y": 5}
var min_pos = {"x":4, "y":1}

var occupier_arr = {}

var prev_cell = null

func calculateMin():
	return {"x":4, "y":((8-max_pos["y"]))/2}

func draw_map(map):
	var rng = RandomNumberGenerator.new()
	min_pos = calculateMin()
	max_pos = {"x": map[0].size()-1, "y": map.size()-1}
	
	for x in range(0, max_pos["x"]+1):
		for y in range(0, max_pos["y"]+1):
			if(map[y][x]=="-"):
				occupier_arr[str(min_pos["x"]+x)+"-"+str(min_pos["y"]+y)] = ""
				if(get_cell_atlas_coords(0,Vector2(min_pos["x"]+x,min_pos["y"]+y))==Vector2i(-1, -1)):
					set_cell(0, Vector2(min_pos["x"]+x,min_pos["y"]+y), 1, Vector2(0,0))
			elif(map[y][x]=="O"):
				occupier_arr[str(min_pos["x"]+x)+"-"+str(min_pos["y"]+y)] = ""
				set_cell(0, Vector2(min_pos["x"]+x,min_pos["y"]+y), 1, Vector2(2,0))
			else:
				occupy_slot(map_to_local(Vector2(min_pos["x"]+x,min_pos["y"]+y)), {
					"type": Diction.name_ext[map[y][x]],
					"texture": Diction.texture[Diction.name_ext[map[y][x]]], 
					"modulate": Color(1-rng.randf_range(0,0.1),1-rng.randf_range(0,0.1),1-rng.randf_range(0,0.1)),
					"rotation": randf_range(-360,360)
				})

func _process(_delta):
	var mouse_pos = local_to_map(get_global_mouse_position())
	if(!in_range(mouse_pos)) or get_parent().curr_player == null:
		if prev_cell != null:
			set_cell(1, prev_cell, 1)
		prev_cell = null
		return
	
	if prev_cell == null:
		prev_cell = mouse_pos
		return
	
	if prev_cell != mouse_pos:
		if(get_cell_atlas_coords(0,mouse_pos)!=Vector2i(2, 0)):
			set_cell(1, mouse_pos, 1, Vector2(1,0))
		set_cell(1, prev_cell, 1)
		
		prev_cell = mouse_pos
	
func occupy_slot(pos, player):
	var mouse_pos = local_to_map(pos)
	if(!in_range(mouse_pos) or get_cell_atlas_coords(0,mouse_pos)==Vector2i(2, 0)):
		return false
	
	set_cell(0, mouse_pos, 1, Vector2(2,0))
	set_cell(1, mouse_pos, 1)
	
	if player.type!="rock" and  player.type!="grass":
		paint_neighbors(player.type, mouse_pos)
	
	var sprite = Sprite2D.new()
	sprite.texture = player["texture"]
	sprite.modulate = player["modulate"]
	sprite.rotation_degrees = player["rotation"]
	sprite.position = map_to_local(mouse_pos)
	add_child(sprite)
	
	occupier_arr[str(mouse_pos.x)+"-"+str(mouse_pos.y)] = player['type']
	
	return true

func paint_neighbors(type, mouse_pos):
	var neighbors = [
		get_neighbor_cell(mouse_pos, self.tile_set.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE ), #CELL_NEIGHBOR_RIGHT_SIDE
		get_neighbor_cell(mouse_pos, self.tile_set.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE ), #CELL_NEIGHBOR_LEFT_SIDE
		get_neighbor_cell(mouse_pos, self.tile_set.CellNeighbor.CELL_NEIGHBOR_BOTTOM_SIDE ), #CELL_NEIGHBOR_BOTTOM_SIDE
		get_neighbor_cell(mouse_pos, self.tile_set.CellNeighbor.CELL_NEIGHBOR_TOP_SIDE ), #CELL_NEIGHBOR_TOP_SIDE
	]
	for neighbor in neighbors:
		if(!in_range(neighbor) or get_cell_atlas_coords(0,neighbor)==Vector2i(2, 0)):
			continue;
		
		if (get_cell_atlas_coords(0,neighbor)!=Vector2i(0, 0) and get_cell_atlas_coords(0,neighbor)!=Vector2i(-1, -1) and 
			!(type=="sun" and get_cell_atlas_coords(0,neighbor)==Vector2i(0, 1)) and
			!(type=="ice" and get_cell_atlas_coords(0,neighbor)==Vector2i(1, 1))):
				set_cell(0, neighbor, 1, Vector2(2,1))
		else:
			if(type=="sun"):
				set_cell(0, neighbor, 1, Vector2(0,1))
			if(type=="ice"):
				set_cell(0, neighbor, 1, Vector2(1,1))
			if(type=="black"):
				if(neighbor == neighbors[0]):
					set_cell(0, neighbor, 1, Vector2(2,2))
				if(neighbor == neighbors[1]):
					set_cell(0, neighbor, 1, Vector2(3,2))
				if(neighbor == neighbors[2]):
					set_cell(0, neighbor, 1, Vector2(1,2))
				if(neighbor == neighbors[3]):
					set_cell(0, neighbor, 1, Vector2(0,2))

func in_range(pos):
	return bool(pos.x>=min_pos["x"] and pos.x<=min_pos["x"]+max_pos["x"] and pos.y>=min_pos["y"] and pos.y<=min_pos["y"]+max_pos["y"])

func check_success(pos, player):
	var mouse_pos = local_to_map(pos)
	var neighbors = [
		get_neighbor_cell(mouse_pos, 0 ), #CELL_NEIGHBOR_RIGHT_SIDE
		get_neighbor_cell(mouse_pos, 4 ), #CELL_NEIGHBOR_LEFT_SIDE
		get_neighbor_cell(mouse_pos, 8 ), #CELL_NEIGHBOR_BOTTOM_SIDE
		get_neighbor_cell(mouse_pos, 12 ), #CELL_NEIGHBOR_TOP_SIDE
	]
	
	for neighbor in neighbors:
		var source_id = self.get_cell_source_id(0, neighbor, false)
		if(source_id == -1):
			continue

		var occupier = occupier_arr[str(neighbor.x)+"-"+str(neighbor.y)]
		
		if (occupier=="black" or 
			(player.type=="black" and occupier != "") or
			(player.type=="ice" and occupier == "sun") or
			(player.type=="sun" and occupier == "ice") or
			(player.type=="grass" and occupier == "sun") or
			(player.type=="grass" and occupier == "ice") or
			(player.type=="ice" and occupier == "grass") or
			(player.type=="sun" and occupier == "grass")):
				return false
	
	return true
	
