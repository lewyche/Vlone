extends Control

onready var player = get_node("../../Player")

func activate():
	print("balls")
	visible = true
	
func deactivate():
	visible = false

func _ready():
	pass # Replace with function body.
	
func _on_Restart_pressed():
	player.restart()

func _on_Quit_pressed():
	get_tree().quit()
