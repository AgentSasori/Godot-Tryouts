extends Actor
class_name Enemy

export var _score := 100

func _physics_process(delta):
	_velocity.y += _gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func _on_HitDetector_body_entered(body):
	if body.global_position.y > get_node("HitDetector").global_position.y:
		return
	die()

func _ready():
#	disable mob physics when outside of view
	set_physics_process(false)
	_velocity.x = -_speed.x
	
func die():
	get_node("CollisionShape2D").disabled = true
	queue_free()
	PlayerData.set_score(PlayerData.get_score() + _score)