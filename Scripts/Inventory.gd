extends Control

var player_inventory = {}

onready var item_button = preload("res://UI/Item_button.tscn")

var open = false

var icon = "res://placeholder.png"

func show_inventory():
	visible = true
	open = true

func hide_inventory():
	visible = false
	open = false

func add_item(name, num):
	if player_inventory.has(name):
		player_inventory[name] += num
	else:
		player_inventory[name] = num
	display_inventory()
	
func add_icon(icon_path):
	icon = "res://" + icon_path

func _ready():
	pass # Replace with function body.

func clear():
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.queue_free()

func display_inventory():
	clear()
	for i in player_inventory.keys():
		var new_button = item_button.instance()
		$ScrollContainer/VBoxContainer.add_child(new_button)
		new_button.set_text_and_icon(str(player_inventory[i]) + " " + i, icon)
