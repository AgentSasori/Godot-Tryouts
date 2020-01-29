extends Control

func _on_continue_pressed():
	_hide_menues()
	
func _on_new_game_pressed():
	_hide_menues()
	get_node("PanelContainer/NewGameMenu").show()
	
func _on_load_game_pressed():
	_hide_menues()
	get_node("PanelContainer/LoadGameMenu").show()
	
func _on_join_server_pressed():
	_hide_menues()
	get_node("PanelContainer/JoinServerMenu").show()
	
func _on_settings_pressed():
	_hide_menues()
	
func _on_quit_pressed():
	get_tree().quit()
	
# Hide button spesific menues
func _hide_menues():
	for childNode in get_node("PanelContainer").get_children():
		childNode.hide()
