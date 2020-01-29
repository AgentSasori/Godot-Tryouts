extends Control

func _on_create_game_pressed():
	var loadingscreen = load("res://src/scenes/Loadingscreen.tscn").instance()
	get_node("/root").add_child(loadingscreen)
	get_tree().change_scene_to(loadingscreen)
	
	var server:Server = load("res://src/classes/Server.tscn").instance()
	server.set_name("Server")
	get_node("/root").add_child(server)
	server.create_server()
	
	var game:Game = load("res://src/scenes/Game.tscn").instance()
	get_node("/root").add_child(game)
	
	loadingscreen.get_node("LoadingContainer/Label").set_text("Creating world")
	var map = game.generate_map()
	
	loadingscreen.get_node("LoadingContainer/Label").set_text("Loading player")
	
	Globals.set_self_player_name("host")
	Globals.set_self_peer_id(1)# Server hast always id 1
	Globals.connected_clients[Globals.get_self_peer_id()] = Globals.get_self_data()
	
	var player = game.create_player(str(Globals.get_self_peer_id()), Globals.get_self_data(), Globals.get_self_peer_id())
	
	get_tree().change_scene_to(map)
	get_node(Globals.NODE_PATH_PLAYERS).add_child(player)
	get_node("/root/Loadingscreen").queue_free()
