extends Node2D

var show = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#.position
	# self.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if show:
		$WindowDialog.visible = true
		#position = get_parent().position
		#self.position = position		
		#print(get_parent().name, " (Woodenbox) is visible at ", position)
	else : $WindowDialog.visible = false


func _on_Area2D_body_entered(body):
	print("Player entered Woodenbox-Area2D for the inventory")
	if body.is_in_group("player"):
		#show = true
		$WindowDialog.visible = true
		print($WindowDialog.visible)
		print(get_parent().name)
		print(get_parent().get_position_in_parent())
		print(get_parent().position)
		print(get_position())
		self.set_position(get_parent().position)
		$WindowDialog.set_position(get_parent().position)
		print(get_position())
		print(get_parent().get_global_position())
		#print(".".position)


func _on_Area2D_body_exited(body):
	print("Player EXITED")
	if body.is_in_group("player"):	
		show = false
		$WindowDialog.visible = false
		print($WindowDialog.visible)
