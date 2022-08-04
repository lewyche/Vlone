extends RigidBody2D

onready var inventory = get_node("../../Player/CanvasLayer/Inventory")
export var value = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_item():
	pass

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		add_item()
		queue_free()
