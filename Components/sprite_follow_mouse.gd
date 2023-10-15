extends Area2D

@export var type = "planet"

@onready var sprite = $Sprite2D

func _ready():
	sprite.texture = Diction.texture[type]

func _process(_delta):
	global_position = get_global_mouse_position()
