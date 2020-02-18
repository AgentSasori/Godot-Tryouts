extends Node2D

var near_bodies = []
var burn_time = rand_range(10, 30) #sec

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.connect("body_enter", self, "_on_Area2D_body_entered")
	#set_process(true)
	#check_rotation()
	
	# Timer for checking the neighbors for setting on fire *hehe*
	$Timer_1s.set_wait_time(1)
	
	# Timer for fire flickering (light2d)
	$Timer_005s.set_wait_time(0.05)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if self.rotation != 0:
#		#print("self-rotation is ", self.rotation)
#		self.rotation_degrees += 1
#		#self.rotation = 0
#	#self.rotation_degrees += 1
#	self.rotation = 0
	#print(self, " is in process")	
	check_rotation()

# Correct the rotation of the fire  _ NOT WORKING _
func check_rotation():
	if self.get_parent() != null:
		self.rotation = -self.get_parent().rotation
	else:
		print("##############################")
		print(self.name)

# BODY directly hits the fire: SET IT ON FIREEEEE
func _on_Area2D_body_entered(body):
	#print(">>> BODY ENTERED FIRE: ", body)
	_set_on_fire(body)

# Send the body on fire (if can burn)
func _set_on_fire(body):
	if body.is_in_group("can_burn"):
		
		#print("group: can burn")
		
		# tests with getting a value from a body, ex. burnindex
		#print("value: ", body.burnindex)
		if body.burnindex > 50:
			#print("Doublicated and chiled")
				#myself = load("res://fire.tscn")
				#var newfire = preload("res://fire.tscn")
				###########################new = myself.instance() #get_node("fire").instance()
			#new = load("res://fire.tscn").instance()
			#print("Own pos: ", position)
			#print("body pos: ", body.position)
			#body.add_child(new)
				#new.position = body.position
			#print("child fire pos: ", new.position)
			
			# Call the function to burn
			body.set_on_fire()
			
			# Give body some damage :)
			body.take_damage(rand_range(1, 5))
		else:
			pass #print("Body cannot burn")
			
	

# Time to burn motherfuckers!
func set_neighbors_on_fire():
	for n in near_bodies:
		_set_on_fire(n)
		

# Store all bodies near fire to set them on fire later (triggered by timer1)
func _on_Area2D_near_body_entered(body):
	print(self, " body entered: ", body)
	near_bodies.append(body)
	#_set_on_fire(body)
	print("- list has: ", near_bodies)

# remove bodies outside the "near-field"
func _on_Area2D_near_body_exited(body):
	print(self, " body exited: ", body)
	near_bodies.erase(body)
	print("- list has: ", near_bodies)

# TRIGGERED by timer for flickering the fire
func _on_Timer_005s_timeout():
	$Light2D.energy = lerp(0, rand_range(0, 1), 0.8)#rand_range(0, 1)
	
# Timer to check rotation and the neighbor
func _on_Timer_1s_timeout():	
	set_neighbors_on_fire()
	burn_time -= 1
	if burn_time <= 0:
		self.queue_free()
	print(self, " burntime = ", burn_time)
