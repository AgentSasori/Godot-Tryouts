extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var server_list = _load_server_list()
	
	for server in server_list:
		var list_item:ServerListItem = load("res://src/ui/ServerListItem.tscn").instance()
		list_item.load_values(server)
		list_item.connect("server_item_doubleclick", self, "_join_server")
		get_node("ServerList").add_child(list_item)

func _load_server_list():
	return [
		{
			name = "Placeholder",
			ip = "127.0.0.1",
			port = 4242,
		}
	]
	
func _join_server(ip:String, port:int):
	print("clicked")
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
