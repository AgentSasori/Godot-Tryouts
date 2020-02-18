extends Control

var _server_list_file := "serverlist.json"
var _server_list:Array

func _ready():
	_load_server_list()

# Open "AddNewServer" popup
func _on_add_server_pressed():
	var popup = load("res://src/scenes/AddNewServer.tscn").instance()
	get_node(".").add_child(popup)
	popup.popup()
	popup.connect("on_cancel_pressed", self, "_on_add_new_server_cancel_pressed")
	popup.connect("on_save_pressed", self, "_on_add_new_server_save_pressed")

func _on_add_new_server_cancel_pressed():
	get_node("AddNewServer").queue_free()

# Save new server
func _on_add_new_server_save_pressed():
	var popup       = get_node("./AddNewServer")
	var server_name = popup.get_node("VBoxContainer/ServerName/Input").text
	var ip          = popup.get_node("VBoxContainer/ServerAddress/Input").text
	var port        = popup.get_node("VBoxContainer/ServerPort/Input").text
	
#	todo check ip with regex before
	if ip != "":
		_server_list.append({
			name = server_name if server_name != "" else "New Server",
			ip   = ip,
			port = int(port) if port != "" else 4242,
		})
		
		_save_server_list()
		_refresh_server_list()
		popup.queue_free()
		
	else:
#		todo show message popup with message "invalid server ip"
		pass

# Load server list from file
func _load_server_list():
	var result = FileHandler.read_json_file(_server_list_file)
	if result:
		_server_list = result
	_refresh_server_list()

# Refres ui server list
func _refresh_server_list():
	for child in $ServerList.get_children():
		child.queue_free()

	for server in _server_list:
		var list_item:ServerListItem = load("res://src/ui/ServerListItem.tscn").instance()
		list_item.load_values(server)
		list_item.connect("server_item_doubleclick", self, "_join_server")
		get_node("ServerList").add_child(list_item)

# Save server list to file
func _save_server_list():
	FileHandler.save_data_as_json(_server_list_file, _server_list)

# Join selected server
func _join_server(ip:String, port:int):
	Globals.set_self_player_name("test")
	
	var loadingscreen = load("res://src/scenes/Loadingscreen.tscn").instance()
	get_node("/root").add_child(loadingscreen)
	get_tree().change_scene_to(loadingscreen)
	
	var client:Client = load("res://src/classes/Client.tscn").instance()
	client.set_name("Server")
	client.server_ip = ip
	client.server_port = port

	get_node("/root").add_child(client)
	
	client.join_server()
