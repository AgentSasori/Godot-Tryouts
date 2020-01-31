extends Control

func _on_create_game_pressed():
	var loadingscreen = load("res://src/scenes/Loadingscreen.tscn").instance()
	get_node("/root").add_child(loadingscreen)
	get_tree().change_scene_to(loadingscreen)
	
	Globals.set_self_player_name("host")
	Globals.set_self_peer_id(1)# Server hast always id 1
	
	_init_server()
	
	var game:Game = load("res://src/scenes/Game.tscn").instance()
	game.game_name = $Details/InputName.text if $Details/InputName.text != "" else "A brand new world"
	game.game_seed = $Details/InputSeed.text if $Details/InputSeed.text != "" else _generate_seed()
	get_node("/root").add_child(game)
	game.init_game(Globals.get_self_peer_id(), Globals.get_self_data())
	
	Globals.connected_clients[Globals.get_self_peer_id()] = Globals.get_self_data()

func _on_input_name_focus_exited():
	$Details/InputSeed.set_text(_generate_seed())

func _on_new_randome_seed_pressed():
	$Details/InputSeed.set_text(_generate_seed())

# Init server node
func _init_server():
	var server:Server = load("res://src/classes/Server.tscn").instance()
	server.set_name("Server")
	get_node("/root").add_child(server)
	server.create_server()

# Generate new randome seed
func _generate_seed() -> String:
	var string = str(OS.get_system_time_msecs()) + $Details/InputName.text
	string = string.md5_text()
	
	var tmp = ""
	# Remove all charakter from string and only save digets
	for a_char in string:
		if a_char.is_valid_integer():
			tmp += a_char
	
	randomize()
	var start = rand_range(0, tmp.length() - 6)
	var end = rand_range(start + 4, tmp.length())
	
	return tmp.substr(start, end)
