extends PopupDialog

# todo always save game when leaving

# Back to main menu
func _on_disconnect_pressed():
	get_node("/root/Game").save_game()
	get_tree().network_peer = null;
	get_tree().change_scene("res://src/scenes/MainMenu.tscn")
	get_node("/root/Game").queue_free()
	get_node("/root/Server").queue_free()
	self.queue_free()

# Quite game
func _on_quit_pressed():
	get_node("/root/Game").save_game()
	get_tree().quit()

# Save game
func _on_save_game_pressed():
	get_node("/root/Game").save_game()
