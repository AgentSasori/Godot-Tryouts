extends Actor
class_name Player

var p_layer_name:String setget set_player_name
var player_position

func _ready():
	player_position = Globals.get_self_position()
	create_ui()

func _physics_process(delta):
	# only for the player that is assigned to the local network_master
	# Local network_master is refered to by the peer_id
	# The peer_id is assigned to the player object in function Games.create_player
	if is_network_master():
		_handle_movement(delta)
		rpc_unreliable("_update_position", Globals.get_self_peer_id(), player_position)
		
		if Input.is_action_just_pressed("menu"):
			var menu:CanvasLayer = $PlayerView.get_node("Ui")
			if menu.get_node_or_null("Popup") == null:
				var menu_popup = load("res://src/scenes/Menu.tscn").instance()
				menu.add_child(menu_popup)
				menu_popup.popup()
			else:
				menu.get_node("Popup").queue_free()
	
	position = player_position

func _handle_movement(delta:float):
	var velocity = Vector2()  # The player's movement vector.

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * _speed
		player_position += velocity * delta

# Setter for propertie player_name
func set_player_name(player_name):
	$CharacterSprite/Playername.text = player_name

func create_ui():
	pass

# Update character movement
remote func _update_position(client_id, client_position):
	Globals.connected_clients[client_id].position = client_position
	player_position = client_position
