extends Node
class_name Server

func create_server():
	Globals.debug(self.get_script().get_path(), "starting server")
#
	var server = NetworkedMultiplayerENet.new()
	if server.create_server(Globals.config["server"]["port"], Globals.config["server"]["maxPlayerCount"]) != OK:
		Globals.debug(self.get_script().get_path(), "Error creating server")
		return
		
	get_tree().set_network_peer(server)
	Globals.set_self_peer_id(get_tree().get_network_unique_id())
	
	Globals.debug(self.get_script().get_path(), "server started")
	
	# Register connection signals after server is created
	server.connect("peer_connected", self, "_on_client_connected")
	server.connect("peer_disconnected", self, "_on_client_disconnected")

# Handle connection of new clients
func _on_client_connected(connected_client_id):
	Globals.debug(self.get_script().get_path(), "client connected to server: " + str(connected_client_id))	
	Globals.debug(self.get_script().get_path(), "Request client data")
	
	_request_client_data(connected_client_id)

# Request data form newly conencted client
func _request_client_data(client_id):
	rpc_id(client_id, "_send_data_to_server")

# Client disconnected
func _on_client_disconnected(disconnected_client_id):
	Globals.debug(self.get_script().get_path(), "Client disconnected from server " + str(disconnected_client_id))
	
#	Update client data for saving when client disconnects
	Globals.persistent_client_data = Globals.connected_clients[disconnected_client_id]
	
#	Remove player node
	get_node(Globals.NODE_PATH_PLAYERS).get_node(str(disconnected_client_id)).queue_free()
	
#	Remove client from connected client list
	Globals.connected_clients.erase(disconnected_client_id)
	
#	Send informations to other clients about disconnected client
	for client_id in Globals.connected_clients:
		rpc_id(client_id, "_unregister_client", disconnected_client_id)

# Send client data of newly connected client to existing clients
# and existing clients to newly connected client
func _sync_clients(new_client_id, new_client_data):
#	If client was already on server use persisten client data. If client was not on the server
#	before use new client data
	if Globals.persistent_client_data.has(new_client_data["game_hash"]):
		Globals.connected_clients[new_client_id] = Globals.persistent_client_data[new_client_data["game_hash"]]
		Globals.connected_clients[new_client_id]["player_name"] = new_client_data["player_name"]
	else:
		new_client_data["position"] = Globals.spawn_position
		Globals.connected_clients[new_client_id] = new_client_data
		Globals.persistent_client_data[new_client_data["game_hash"]] = new_client_data
	
	for client_id in Globals.connected_clients:
		if not get_tree().is_network_server():
			Globals.debug(self.get_script().get_path(), "Send new client data to existing client " + str(client_id))
			# Send new client data to existing clients
			rpc_id(client_id, "_register_client", new_client_id, new_client_data)
		
		Globals.debug(self.get_script().get_path(), "Send existing client data to new client " + str(new_client_id))
		#Send existing clients data to new client
		rpc_id(new_client_id, "_register_client", client_id, Globals.connected_clients[client_id])

# Recieve client data from new connected client
remote func _recieve_client_data(data):
	Globals.debug(self.get_script().get_path(), "Recieving client data:\n" + str(data))
	
#	possibility  for a whitelist functionality
	
	get_node(Globals.NODE_PATH_PLAYERS).add_child(
		get_node(Globals.NODE_PATH_GAME).create_player(str(get_tree().get_rpc_sender_id()), data, get_tree().get_rpc_sender_id())
	)
	
	_sync_clients(get_tree().get_rpc_sender_id(), data)
