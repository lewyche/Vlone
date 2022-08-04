extends Area2D

func _ready():
	pass # Replace with function body.


func _on_LevelEnd_body_entered(body):
	get_tree().change_scene("res://Levels/Main Scene.tscn")
