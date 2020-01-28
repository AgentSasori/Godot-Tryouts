tool
extends Area2D
class_name Portal2D

export var next_scene: PackedScene

onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _on_Portal2D_body_entered(body):
	teleport()

func _get_configuration_warning():
	return "The next scene has not been set" if not next_scene else ""
	
func teleport():
	_animation_player.play("fade_in")
	yield(_animation_player, "animation_finished")
	get_tree().change_scene_to(next_scene)