extends RigidBody2D

#onready var itemlist = preload ("res://itemlist.gd")

export var storage = 2
export var hp = 100
export var burnindex = 70
export var pickable = false

export var inventory : Dictionary

const fire_hnd = preload("fire.tscn")

var on_fire = false

func _ready():
	#inventory.append()
	pass # Replace with function body.

func set_on_fire():
	if !on_fire:
		var fire = fire_hnd.instance()
		if fire:
			# fire.check_rotation()
			self.add_child(fire)
			on_fire = true
			#print("I AM ON FIRE ", self)
		#fire.instance()
		#print(self.call_deferred("add_child",fire))	
		#print(self)
		#print(get_parent())
		#self.add_child(fire)
		#get_parent().add_child(fire)
		#fire.set = position
	#else: print("<- already on fire")

func take_damage(value:int):
	hp -= value
	print(self, " took damage: ", value, " and has left: ", hp)
	
	if hp <= 0:
		print(self, " is broken and will disappear")
		self.queue_free()
