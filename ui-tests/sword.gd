extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_animating = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_pressed("ui_accept"):
		$AnimationPlayer.play("swing")
		is_animating = true
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if !body.is_in_group("player") && !body == self:
		print("--- SWORD")
		print(body, " collided")

		# Give body a nicely force if player swings sword
		if is_animating:
			var dir = body.global_position.x - global_position.x
			if body.has_method("apply_impulse"):
				print("IMPULLLLSEEEEE")
				body.apply_impulse(position, Vector2(dir * 10, 0))
			else : print("Body ", body, " has no physics")

		# give body some damage!
		if body.has_method("take_damage"):
			body.take_damage(10)
		else : print("Body ", body, " cant take damage")
		
		# Stop the sword animation 
		$AnimationPlayer.stop()
		is_animating = false
		
		# do some FX
		$particle_hit.global_position = body.global_position
		$particle_hit.restart()

# detect end of animation
func _on_AnimationPlayer_animation_finished(anim_name):
	print("ANMIATION FINISHED")
	is_animating = false
