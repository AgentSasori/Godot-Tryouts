extends Node2D
class_name Game

var game_name:String
var game_seed:String

# Init root game node
func init_game(peer_id:int, data:Dictionary):
	var world  = prepare_world(Globals.SPAWN_WORD)
	var map    = generate_map()
	var player = create_player(str(peer_id), data, peer_id)
	
#	Only set the camera of ur player node to current camera
	player.get_node("PlayerView").current = true
	
	world.add_child(map)
#	map has to be on position 0 to be always in the background
	world.move_child(map, 0)
	
	get_node(Globals.PATH_PLAYER_NODES).add_child(player)
	
#	todo spawn position should be calculated after map generation
	player.player_position = Globals.spawn_position
	Globals.set_self_position(Globals.spawn_position)
	
	get_tree().change_scene_to(map)
	get_node("/root/Loadingscreen").queue_free()

func prepare_world(world_name:String) -> Node:
	var world = Node.new()
	world.name = world_name
#	"World_" + str(get_node(Globals.PATH_GAME_NODE).get_child_count())
	
	var objects = Node.new()
	objects.name = "Objects"
	world.add_child(objects)
	
	var enemies = Node.new()
	enemies.name = "Enemies"
	world.add_child(enemies)
	
	var players = Node.new()
	players.name = "Players"
	world.add_child(players)
	
	get_node(Globals.PATH_GAME_NODE).add_child(world)
	
	return world

func generate_map() -> Node:
	get_node("/root/Loadingscreen/LoadingContainer/Label").set_text("Creating world")
	
	var map = load("res://src/scenes/placeholder.tscn").instance()
	map.name = "Map"

	return map

# Creates a new instance of a player node
func create_player(node_name:String, player_data:Dictionary, network_master:int) -> KinematicBody2D:
	var player = preload("res://src/actors/Player.tscn").instance()
	player.set_name(node_name) # Name of the player note
	player.set_network_master(network_master)
	player.set_player_name(player_data["player_name"]) # visible name for other player
	
	player.player_position = player_data["position"]
	
	return player

func save_game():
	if get_tree().is_network_server():
		print("game saved")
