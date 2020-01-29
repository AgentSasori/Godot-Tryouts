extends RigidBody2D

export var _value = 10

var resource = {type: "crystal", value: _value}

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		print("player colledted ", self.name)
		queue_free()
