extends KinematicBody2D

export var speed = 200
var facing_right = true
var dead = false

onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	pass
func move():
	var velocity = Vector2()
	
	if facing_right == true:
		velocity.x = speed
	else:
		velocity.x = -speed
	return velocity

func change_direction():
	if facing_right:
		facing_right = false
		$Sprite.scale.x = 0.13
	else:
		facing_right = true
		$Sprite.scale.x = -0.13

func restart():
	$Sprite.visible = true
	$CollisionShape2D.disabled = false
	dead = false
	$AnimationPlayer.play("Idle")

func die():
	print("balls")
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("Death")

	dead = true
	#$Sprite.visible = false


func _physics_process(delta):
	if dead == false:
		var collision_info = move_and_collide(move() * delta)
		if collision_info:
			var collider = collision_info.get_collider()
			if collider.is_in_group("Player"):
				if player.parrying == true:
					die()
				else:
					player.die()
			if collider.is_in_group("Bullet"):
				die()
			change_direction()
		
	#if position.x <= -120 || position.x >= 120:
		#change_direction()
