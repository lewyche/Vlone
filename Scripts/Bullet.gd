extends KinematicBody2D

var velocity = Vector2()
export var SPEED = 500
var fired = false

func fire(facing_right, pos, p_velocity):
	position = pos
	if facing_right == true:
		position.x += 50
		velocity.x = SPEED + p_velocity.x
	else:
		position.x -= 50
		velocity.x = -SPEED + p_velocity.x
	fired = true

func die():
	queue_free()

func _physics_process(delta):
	if fired == true:
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			if collision_info.get_collider().is_in_group("Enemy"):
				velocity = velocity.bounce(collision_info.normal)
				collision_info.get_collider().die()
			else:
				die()
		
func _ready():
	pass # Replace with function body.
