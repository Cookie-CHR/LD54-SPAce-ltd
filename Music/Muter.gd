extends Node

var mute = false

func _ready():
	pass;

func get_mute():
	return mute

func mute_unmute():
	if (mute):
		mute = false
		MusicPlayer.play()
	else:
		mute = true
		MusicPlayer.stop()
