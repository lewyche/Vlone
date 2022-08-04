extends KinematicBody2D

export var speed = 200
export var firing_range = 500
var moving_up = true
var dead = false

var velocity = Vector2()

onready var enemy_bullet = preload("res://Props/Enemy_Bullet.tscn")

onready var player = get_node("../../Player")

func _ready():
	pass # Replace with function body.

func move():
	velocity = Vector2()
	if moving_up:
		velocity.y = -speed
	else:
		velocity.y = speed
	return velocity

func change_direction():
	if moving_up:
		moving_up = false
	else:
		moving_up = true

func restart():
	$Sprite.visible = true
	$CollisionShape2D.disabled = false
	dead = false

func die():
	$Sprite.visible = false
	$CollisionShape2D.disabled = true
	dead = true

func create_bullet():
	var new_bull = enemy_bullet.instance()
	get_parent().add_child(new_bull)
	new_bull.fire(player.position, position)

func shoot():
	if $Cooldown.time_left == 0:
		$Cooldown.start()
		create_bullet()

#flip enemy so it is always facing player
func check_player_position():
	if player.position.x < position.x:
		$Sprite.scale.x = 0.13
	elif player.position.x > position.x:
		$Sprite.scale.x = -0.13

func shoot_player():
	var playerX = player.position.x
	var playerY = player.position.y
	#distance formula
	var distance = sqrt(pow(playerX - position.x, 2) + pow(playerY - position.y,2))
	if distance <= firing_range:
		shoot()

func _physics_process(delta):
	if dead == false:
		var collision_info = move_and_collide(move() * delta)
		if collision_info:
			var collider = collision_info.get_collider()
			if collider.is_in_group("Player"):
				player.die()
			if collider.is_in_group("Bullet"):
				die()
			change_direction()
		check_player_position()
		shoot_player()
		
		
