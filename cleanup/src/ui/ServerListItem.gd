extends Control
class_name ServerListItem

signal server_item_doubleclick

var ip:String
var port:int

func load_values(dictionary:Dictionary):
	self.ip = dictionary["ip"]
	self.port = dictionary["port"]
	self.get_node("HBoxContainer/ServerName").set_text(dictionary["name"])
	
func _on_server_list_item_gui_input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			emit_signal("server_item_doubleclick", ip, port)

func _on_join_pressed():
	emit_signal("server_item_doubleclick", ip, port)
