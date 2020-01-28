extends Area2D

func _on_Apple_body_entered(body):
	queue_free()
