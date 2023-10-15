extends Button

@export var type = "rock"
@export var charges = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	adjust_look(charges)

func _on_pressed():
	if(charges <1):
		return
	if get_parent().curr_player != null:
		get_parent().change_player()
	get_parent().new_player(type)
	charges -=1
	adjust_look(charges)

func adjust_look(_charges):
	for n in get_children():
		remove_child(n)
		n.queue_free()
	for i in range(_charges):
		var sprite = Sprite2D.new()
		sprite.texture = Diction.texture[type]
		
		sprite.position.x = (get_rect().size.x/2)+(float(i)-float(charges/2))*10
		sprite.position.y = get_rect().size.y/2
		add_child(sprite)
		
		AudioPlayer._play(type)
