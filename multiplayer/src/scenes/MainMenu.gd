extends Control

func _on_continue_pressed():
	$PanelContainer.hide()
	
func _on_new_game_pressed():
	_restet_panel_container()
	get_node("PanelContainer/NewGameMenu").show()
	
func _on_load_game_pressed():
	_restet_panel_container()
	get_node("PanelContainer/LoadGameMenu").show()
	
func _on_join_server_pressed():
	_restet_panel_container()
	get_node("PanelContainer/JoinServerMenu").show()
	
func _on_settings_pressed():
	$PanelContainer.hide()
	
func _on_quit_pressed():
	get_tree().quit()
	
# Hide button spesific menues
func _restet_panel_container():
	$PanelContainer.show()
	for childNode in $PanelContainer.get_children():
		childNode.hide()
