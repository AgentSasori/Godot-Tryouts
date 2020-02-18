extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel := Vector2()
export var speed := 200

const inv_popup = preload("res://ItemList.tscn")
var inv_hnd
var	inv_body
var player_inventory := []
var inv_open = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("ITEMS FOUND")
	#print(get_node("../StaticBody2D").items)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vel = Vector2()
	if Input.is_action_pressed("ui_left"):
		vel.x -= 1
	if Input.is_action_pressed("ui_right"):
		vel.x += 1
	if Input.is_action_pressed("ui_up"):
		vel.y -= 1
	if Input.is_action_pressed("ui_down"):
		vel.y += 1
		
	if vel:
		vel = move_and_slide(vel * speed)
		#print(vel)


func _on_Area2D_body_entered(body):
#	print("Player: Body entered ", body)
#	print("name ",body.name)
#	print("pos ", body.position)
#	print("global-pos ", body.global_position)
#	print("Player-Infos:")
#	print("Global-pos ", global_position)
#	print("position ", position)
	
	if body.is_in_group("has_inventory"):
		# instanzieren
		inv_hnd = inv_popup.instance()
		inv_body = body
		if inv_hnd:
			
			inv_open[body] = inv_hnd
			
			print("instanciated ", inv_hnd)
			#inv_hnd.global_position = global_position 
			#inv_hnd.set_position(body.position) # setzt die position RELATIV zum parent-object , also von der box aus!
			print("Inventoy is at ", inv_hnd.get_position())
			# als child anhängen an object (kiste)
			body.add_child(inv_hnd)
			# auf variable zugreifen von kiste
			var inv_items = body.get("items")
			#for i in inv_items:
			print(inv_items) # geht nicht mehr
			
			# print(inv_items[0])
			# print(inv_items[0].Icon)
			# inv_hnd.get_node("Label").text = body.name
			# inv_hnd.get_node("ItemList").add_icon_item(inv_items[0].Icon)
			#inv_hnd.get_node("ItemList").add_icon_item("res://Sprite_key_green.tscn".get_node("Sprite").texture)
			#inv_hnd.get_node("ItemList").add_icon_item(inv_items[0].yellowkey)


func _on_Area2D_body_exited(body):
	print("Player: Body exited ", body)
	if !body.is_in_group("player") && !body.is_in_group("equipment"):
		inv_open[body].queue_free()
#
#	if inv_hnd && inv_body == body:
#		inv_hnd.queue_free() # despawn
