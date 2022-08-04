extends KinematicBody2D

var velocity = Vector2()
export var SPEED = 500
var fired = false

func fire(player_pos, enemy_pos):
	position = enemy_pos
	print(player_pos)
	print(enemy_pos)
	var direction = enemy_pos.direction_to(player_pos)
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	fired = true

func die():
	queue_free()

func _physics_process(delta):
	if fired == true:
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			var collider = collision_info.get_collider()
			if collider.is_in_group("Player"):
				if collider.parrying == true:
					die()
				else:
					collider.die()
			elif collision_info.get_collider().is_in_group("Enemy"):
				velocity = velocity.bounce(collision_info.normal)
			else:
				die()
				
		
func _ready():
	pass # Replace with function body.
