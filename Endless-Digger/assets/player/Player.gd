extends KinematicBody2D

const MAX_INVENTORY_SPACE = 9

# Define moving
export var walk_speed = 110
export var run_speed = 250 # this value will be ADDED to the move_speed!
export var use_gravity = true
export var jump_power = 740 # keep in mind: changing has effect on _is_moving() ... to long in the air will trigger that method! maybe change animation-speed?

var velocity = Vector2()
var gravity = 1500
var move_speed = walk_speed

onready var raycasts = $RayCast2D
onready var anim_player = $AnimatedSprite

var inventory = [MAX_INVENTORY_SPACE]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	# get inputs
	_get_input()	
	# calc gravity if enabled and NOT on ground/surface/tile
	if use_gravity && !_is_grounded(): 
		_player_label_bottom("gavity movement")
		velocity.y += gravity * delta
	else:
		_player_label_bottom("no gravity and grounded")
	# move player
	velocity = move_and_slide(velocity, Vector2(0,-1))	
	
# Moving to direction is holding a key, so _get_input() will triggered		
func _get_input():
	# set standard-moving speed to walking
	move_speed = walk_speed
	
	# check for moving-keys
	if Input.is_action_pressed("ui_shift") && round(velocity.x) != 0:
		move_speed = run_speed
		anim_player.play("run")
		move_speed = run_speed
	elif Input.is_action_pressed("ui_left"):
		anim_player.play("walk")
		move_speed = walk_speed
	elif Input.is_action_pressed("ui_right"):
		anim_player.play("walk")
		move_speed = walk_speed
	
	# check for action-keys
	if Input.is_action_just_pressed("ui_jump") && _is_grounded():
		anim_player.play("jump")
		velocity.y = -jump_power
	elif Input.is_action_just_pressed("ui_hit") && _is_grounded():
		anim_player.play("hit")
	elif Input.is_action_just_pressed("ui_hit"):
		anim_player.play("attack")
	elif Input.is_action_just_pressed("ui_up"):
		anim_player.play("attackup")
	elif Input.is_action_just_pressed("ui_use"):
		anim_player.play("stab")
	
	# flip the sprite to right direction
	if velocity.x > 0:
		anim_player.flip_h = true
	elif velocity.x < 0:
		anim_player.flip_h = false
	
	# set the moving direction for lerping: -1 left    +1 right
	var move_direction = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	# calculate a smooth velocity (movement)
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.5) # last value delays input: 0.1 feels nice and 0.01 like walking on ice
	
	# some tests with labels
	$Camera2D/Label_cam_centerbottom.text = str(gravity)
	
# check if player is colliding under his feets via raycast
func _is_grounded():
	# are we on floor? letz check via our raycast
	if raycasts.is_colliding():
		var col = raycasts.get_collider()
		# on what kind of object are we? which group. if "physical_object" stop velocity and push a little up to prevent bouncing
		if col.is_in_group("physical_object") && velocity.y > 0:
			# stand still
			velocity.y = 0
			# lift up a bit to prevent flipping the object
			position.y -= 1
		return true		
	return false
	
# check if player is moving in any direction
func _is_moving():	
	if round(velocity.x) == 0 && round(velocity.y) == 0:
		_player_label_bottom("Player: is not moving")
		return false
	_player_label_bottom("Player: is moving")
	return true
	
# SIGNAL-RECEIVER if animation has finished: play idle
func _on_AnimatedSprite_animation_finished():
	if !_is_moving() : #round(velocity.x) == 0:
		# print("PLAYER: is idle")
		anim_player.play("idle")

func _player_label_bottom(text:String):
	$Label_bottom.text = "Vel: " + str(velocity) + "\n" + text

# Check for near-area
func _on_Area2D_area_entered(area):
	print("area2d entered: ", area)
	#pass # Replace with function body.

func _on_Area2D_area_exited(area):
	print("area2d exited: ", area)


func _on_Area2D_body_entered(body):
	print("Body entered: ", body)
