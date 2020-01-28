extends KinematicBody2D

export var hp = 100
export var dmg = 5
export var walk_speed = 100
export var run_speed = 2.5
export var jump_speed = 500

var velocity = Vector2()
var anim = "idle"
var gravity = 2500

#func _ready():
#	set_physics_process(true)
#	set_process(true)

func _ready():
	pass

func get_input():
	velocity = Vector2()
	anim = "idle"
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += walk_speed
		anim = "walk"
		$AnimatedSprite.flip_h = true
	if Input.is_action_pressed("ui_left"):
		velocity.x -= walk_speed
		anim = "walk"
		$AnimatedSprite.flip_h = false
	if Input.is_action_pressed("ui_down"):
		velocity.y += walk_speed
		anim = "walk"
	if Input.is_action_pressed("ui_up"):
		velocity.y -= walk_speed
		anim = "walk"
		
	if Input.is_action_pressed("ui_select"):
		anim = "jump"
		velocity.y = -jump_speed
	if Input.is_action_pressed("ui_strg"):
		anim = "attack_slash"
		
	if Input.is_action_pressed("ui_shift"): #and velocity.x != 0:
		velocity *= run_speed
		anim = "run"
		
	$AnimatedSprite.play(anim)
	
	

func move(delta):
	pass
	
func _physics_process(delta):
    velocity.y += gravity * delta
    get_input()
    velocity = move_and_collide(velocity, Vector2(0, -1))	
	#get_input()
	#move_and_slide(velocity * delta)
	
func _on_Apple_body_entered(body):
	print(" collected")
