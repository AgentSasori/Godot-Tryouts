extends Node
class_name Client

var server_ip:String
var server_port:int
var _peer_server_id
var _player:Player

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
	
	var game:Game = load("res://src/scenes/Game.tscn").instance()
	get_node("/root").add_child(game)
	
	Globals.connected_clients[Globals.get_self_peer_id()] = Globals.get_self_data()
	
	_player = game.create_player(str(Globals.get_self_peer_id()), Globals.get_self_data(), Globals.get_self_peer_id())
	get_node("/root/Loadingscreen").queue_free()

func _on_connection_failed(error):
	Globals.debug(self.get_script().get_path(), "Error connecting server\n" + str(error))
	get_node("/root/Loadingscreen").queue_free()

func _on_server_disconnected():
	Globals.debug(self.get_script().get_path(), "Server disconnected")
	get_node(Globals.NODE_PATH_PLAYERS).get_node(str(Globals.get_self_peer_id())).queue_free()
	get_tree().change_scene("res://src/scenes/MainMenu.tscn")

# Send client data to server
remote func _send_data_to_server():
	Globals.debug(self.get_script().get_path(), "Answer server with requested player data")
	_peer_server_id = get_tree().get_rpc_sender_id()
	rpc_id(_peer_server_id, "_recieve_client_data", Globals.get_self_data())
	
	# tmp rendering map and spawn player only after "ok" of server
	# world will be replaced with map recieved from server
	var world = load("res://src/scenes/placeholder.tscn").instance()
	get_node(Globals.NODE_PATH_WORLDS).add_child(world)
	get_tree().change_scene_to(world)
	get_node(Globals.NODE_PATH_PLAYERS).add_child(_player)

# Revieve data of existing clients
remote func _register_client(client_id, client_data):
	Globals.debug(self.get_script().get_path(), "New client " + str(client_data))
	Globals.connected_clients[client_id] = client_data
	get_node(Globals.NODE_PATH_PLAYERS).add_child(
		get_node(Globals.NODE_PATH_GAME).create_player(str(client_id), client_data, client_id)
	)

# Remove client when disconnecteed
remote func _unregister_client(client_id):
	Globals.debug(self.get_script().get_path(), "Client disconnected from server" + str(Globals.get_self_data()))
	Globals.connected_clients.erase(client_id)
	get_node(Globals.NODE_PATH_PLAYERS).get_node(str(client_id)).queue_free()
