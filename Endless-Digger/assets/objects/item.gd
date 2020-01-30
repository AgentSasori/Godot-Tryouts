extends RigidBody2D

export var hp = 100
export var has_inventory = false
export var is_collectable = false
export var is_movable = false
export var is_throwable = false
export var is_usable = false

var player_near := false
#onready var player = get_node("/root/Game").get_node("Player")

func _ready():
	print("ITEM connecting to player stump ")
	get_node("/root/Game/Player/KinematicBody2D").connect("stump", self, "stump")

func stump(_velocity): # works
	if player_near:
		print("ITEM STUMPING")
		#add_central_force(Vector2(-100, -90))
		#add_force(position, Vector2(0, -500))
		apply_impulse(position, -_velocity)
		#apply_torque_impulse()
		print("pos: ", position)
		#position.y -= 200
	else : print("player not near")
	
func _physics_process(delta):
	pass
	
func Kick(_velocity):
	apply_impulse(position, _velocity)
	
func _on_Area2D_area_exited(area):
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player_near = true
		print("player entered ", self.name)


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		player_near = false
		print("player exited ", self.name)
