extends Button

func _on_RetryButton_pressed():
	PlayerData.set_score(0)
	
#	unpause game
	get_tree().paused = false
	
	get_tree().reload_current_scene()
