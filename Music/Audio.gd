extends AudioStreamPlayer

func _ready():
	if self.connect("finished", reset_to_default):
		print("An error has occurred: could not connect the sound")

func _play(sound):
	volume_db = 2
	self.stream = load("res://Music/"+sound+".mp3")
	if(not Muter.mute):
		play()
	



func reset_to_default():
	pass
