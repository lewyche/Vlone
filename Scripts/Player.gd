extends KinematicBody2D

onready var bullet = preload("res://Props/Bullet.tscn")

#Movement
export var GRAVITY = 50
export var MAXFALLSPEED = 200
export var MAXSPEED = 80
export var JUMPFORCE = 500
export var DASHMULTIPLER = 35
var ACCEL = 50
var multipler = 1
var velocity = Vector2()

#Double jumps
export var jumps = 2
var times_jumped = 0

var dead = false

var facing_right = true

var parrying = false

onready var game_over = get_node("../CanvasLayer/Game Over")

onready var enemies = get_parent().get_node("Enemies")

func _ready():
	global_position = get_parent().get_node("spawn_point").global_position
	
func shoot():
	var new_bullet = bullet.instance()
	#add bullet to parent of player so that the bullets do not move relative to the player
	get_parent().add_child(new_bullet)
	new_bullet.fire(facing_right, global_position, velocity)

#scale by 0.13 otherwise, the sprite will be messed up
func change_sprite_direction():
	if facing_right == true:
		$Sprite.scale.x = 0.13
	else:
		$Sprite.scale.x = -0.13

func get_input():
	change_sprite_direction()
	
	if Input.is_action_pressed("right"):
		facing_right = true
		velocity.x += ACCEL * multipler
	elif Input.is_action_pressed("left"):
		facing_right = false
		velocity.x += -ACCEL * multipler
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
		
	if Input.is_action_just_pressed("jump"):
		if times_jumped < jumps:
			velocity.y = -JUMPFORCE
			times_jumped += 1
		elif is_on_wall():
			if facing_right:
				velocity.x += -JUMPFORCE
			else:
				velocity.x += JUMPFORCE
			velocity.y = -JUMPFORCE
	
	if Input.is_action_just_pressed("dash"):
		if $Cooldown.time_left == 0:
			multipler = DASHMULTIPLER
			$Cooldown.start()
	else:
		multipler = lerp(multipler, 1, 0.2)
			

			
	if Input.is_action_just_pressed("shoot"):
		if $Cooldown.time_left == 0:
			$Cooldown.start()
			shoot()
	elif Input.is_action_just_pressed("swing"):
		parrying = true
		$AnimationPlayer.play("Swing")
		
	if Input.is_action_just_pressed("open_inventory"):
		if $CanvasLayer/Inventory.open == false:
			$CanvasLayer/Inventory.show_inventory()
		elif $CanvasLayer/Inventory.open == true:
			$CanvasLayer/Inventory.hide_inventory()
			

func _physics_process(delta):
	if dead == false:
	
		velocity.y += GRAVITY
		if velocity.y >= MAXFALLSPEED:
			velocity.y = MAXFALLSPEED
		
		#limit velocity to maxspeed
		velocity.x = clamp(velocity.x, -MAXSPEED, MAXSPEED)
		
		get_input()
		
		if is_on_floor():
			times_jumped = 0

		velocity = move_and_slide(velocity, Vector2.UP)

func kill_enemies():
	for i in enemies.get_children():
		i.die()

func restart_enemies():
	for i in enemies.get_children():
		i.restart()

func restart():
	global_position = get_parent().get_node("spawn_point").global_position
	$Sprite.visible = true
	dead = false
	game_over.deactivate()
	restart_enemies()

func die():
	print("died!")
	dead = true
	$Sprite.visible = false
	game_over.activate()
	kill_enemies()

func _on_AnimationPlayer_animation_finished(anim_name):
	#reset player animation
	$AnimationPlayer.play("Idle")
	parrying = false
