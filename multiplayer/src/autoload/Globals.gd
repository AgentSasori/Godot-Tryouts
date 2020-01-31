extends Node

const SPAWN_WORD   = "SpawnWorld"

const PATH_GAME_NODE        = "/root/Game"
const PATH_PLAYER_NODES     = PATH_GAME_NODE + "/" + SPAWN_WORD + "/Players"
const PATH_ENEMIE_NODES     = PATH_GAME_NODE + "/" + SPAWN_WORD + "/Enemies"
const PATH_OBJECT_NODES     = PATH_GAME_NODE + "/" + SPAWN_WORD + "/Objects"
const PATH_SPAWN_WORLD      = PATH_GAME_NODE + "/" + SPAWN_WORD
const PATH_SPAWN_WORLD_MAP  = PATH_GAME_NODE + "/" + SPAWN_WORD + "/Map"

var _config_file := "config.json"

var config : Dictionary = FileHandler.read_json_file_as_dictionary(_config_file)
var connected_clients : Dictionary = {}
var persistent_client_data : Dictionary = {}
var spawn_position = Vector2(400,200)

var _self_data = {
	game_hash = FileHandler.read_game_hash(),
	peer_id = null,
	player_name = "",
	position = Vector2(),
}

func get_self_data() -> Dictionary:
	return _self_data

func get_self_game_hash() -> String:
	return _self_data["game_hash"]

func set_self_peer_id(peer_id:int):
	_self_data["peer_id"] = peer_id

func get_self_peer_id() ->int:
	return _self_data["peer_id"]

func set_self_player_name(name:String):
	_self_data["player_name"] = name

func get_self_player_name() -> String:
	return _self_data["player_name"]

func set_self_position(position:Vector2):
	_self_data["position"] = position

func get_self_position() -> Vector2:
	return _self_data["position"]

func debug(file:String, message:String):
	print(file + " " + message)
