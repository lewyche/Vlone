extends Area2D

onready var inventory = get_node("../../Player/CanvasLayer/Inventory")
export var value = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_item():
	inventory.add_item("Coin", 1)
	inventory.add_icon("Assets/Coin.png")

func play_sound():
	get_parent().play("res://Sounds/Coin_collect.wav")

func _on_Coin_body_entered(body):
	if body.get_name() == "Player":
		add_item()
		play_sound()
		queue_free()

