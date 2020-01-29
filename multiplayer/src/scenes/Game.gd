extends Node2D
class_name Game

var game_name:String
var game_seed:int

func generate_map() -> Node:
	var map = load("res://src/scenes/placeholder.tscn").instance()
	get_node(Globals.NODE_PATH_WORLDS).add_child(map)
	
	return map

func create_player(node_name:String, player_data:Dictionary, network_master:int) -> KinematicBody2D:
	var player = preload("res://src/actors/Player.tscn").instance()
	player.set_name(node_name) # Name of the player note
	player.set_player_name(player_data["player_name"]) # visible name for other player
	Globals.debug(self.get_script().get_path(), "network_master " + str(network_master))
	player.set_network_master(network_master)
	
	return player

func save_game():
	if get_tree().is_network_server():
		print("game save")
