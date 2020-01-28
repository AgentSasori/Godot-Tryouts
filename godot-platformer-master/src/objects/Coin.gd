extends Area2D
class_name Coin

onready var _animation_player: AnimationPlayer = get_node("AnimationPlayer")

export var _score := 100

func _on_Coin_body_entered(body):
	picked()
	
func picked():
	_animation_player.play("fade_out")
	PlayerData.set_score(PlayerData.get_score() + _score)