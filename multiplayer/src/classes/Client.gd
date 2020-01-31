extends Node
class_name Client

var server_ip:String
var server_port:int
var _peer_server_id

func join_server():
	Globals.debug(self.get_script().get_path(), "joining server")
	
	var client = NetworkedMultiplayerENet.new()
	client.create_client(server_ip, server_port)
	get_tree().set_network_peer(client)
	
	client.connect("connection_succeeded", self, "_on_connection_succeeded")
	client.connect("connection_failed", self, "_on_connection_failed")
	client.connect("server_disconnected", self, "_on_server_disconnected")
	
	var loadingscreen = load("res://src/scenes/Loadingscreen.tscn").instance()
	add_child(loadingscreen)
	get_tree().change_scene_to(loadingscreen)

func _on_connection_succeeded():
	Globals.set_self_peer_id(get_tree().get_network_unique_id())

# Failed to join server
func _on_connection_failed(error):
	Globals.debug(self.get_script().get_path(), "Error connecting server\n" + str(error))
	get_node("/root/Loadingscreen").queue_free()

# Server closed peer
func _on_server_disconnected():
	Globals.debug(self.get_script().get_path(), "Server disconnected")
	get_node(Globals.PATH_PLAYER_NODES).get_node(str(Globals.get_self_peer_id())).queue_free()
	get_tree().change_scene("res://src/scenes/MainMenu.tscn")

# Send client data to server
remote func _send_data_to_server():
	Globals.debug(self.get_script().get_path(), "Answer server with requested player data")
	_peer_server_id = get_tree().get_rpc_sender_id()
	rpc_id(_peer_server_id, "_recieve_client_data", Globals.get_self_data())

# Revieve data of existing clients
remote func _register_client(client_id, client_data):
	Globals.debug(self.get_script().get_path(), "New client " + str(client_data))
	Globals.connected_clients[client_id] = client_data
	get_node(Globals.PATH_PLAYER_NODES).add_child(
		get_node(Globals.PATH_GAME_NODE).create_player(str(client_id), client_data, client_id)
	)

# Remove client when disconnecteed
remote func _unregister_client(client_id):
	Globals.debug(self.get_script().get_path(), "Client disconnected from server" + str(Globals.get_self_data()))
	Globals.connected_clients.erase(client_id)
	get_node(Globals.PATH_PLAYER_NODES).get_node(str(client_id)).queue_free()

# After access is granted init game
remote func _access_granted(game_name, game_seed, data):
#	maybe replaye complet self_data with data from server
	Globals.set_self_position(data["position"])
	Globals.connected_clients[Globals.get_self_peer_id()] = Globals.get_self_data()
	
	var game:Game = load("res://src/scenes/Game.tscn").instance()
	game.game_name = game_name
	game.game_seed = game_seed
	get_node("/root").add_child(game)
	game.init_game(Globals.get_self_peer_id(), Globals.get_self_data())

remote func _access_denied(message):
	get_node("/root/Loadingscreen").queue_free()
	print(message)
