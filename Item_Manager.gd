extends Node

func play(path):
	$item_audio.stream = load(path)
	$item_audio.play()

func _ready():
	pass
