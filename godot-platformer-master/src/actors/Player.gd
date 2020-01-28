extends Actor

export var stomp_impulse := 1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_EnemyDetector_area_entered(area):
	_velocity = _calc_stomp_velocit(_velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body):
	die()

func _physics_process(delta):
	var is_jumped_interrupted := Input.is_action_just_released("move_up") and _velocity.y < 0.0
	var direction = _calc_direction_vector()
	_velocity = _calc_move_velocity(_velocity, _speed, direction, is_jumped_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
func _calc_direction_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("move_up") and is_on_floor() else 1.0
	)
	
func _calc_move_velocity(linear_velocity: Vector2, speed: Vector2, direction: Vector2, is_jump_interrupted: bool) -> Vector2:
	var new_velocity := linear_velocity
	
	new_velocity.x = _speed.x * direction.x
	new_velocity.y += _gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	
	if is_jump_interrupted:
		new_velocity.y = 0.0
	
	return new_velocity
	
func _calc_stomp_velocit(linear_velocity: Vector2, impules: float) -> Vector2:
	var out := linear_velocity
	out.y -= impules
	return out
	
func die():
	PlayerData.set_deaths(PlayerData.get_deaths() + 1)
	queue_free()