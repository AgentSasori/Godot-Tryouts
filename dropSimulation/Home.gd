tool
extends Node

var pool:int
var runs:int = 0
var drops := {}

export var _tiers = [
	{
		'tier_name' : 'tier 0',
		'drop_chance' : 90.125,
	},
	{
		'tier_name' : 'tier 1',
		'drop_chance' : 60.25,
	},
	{
		'tier_name' : 'tier 2',
		'drop_chance' : 40.5,
	},
	{
		'tier_name' : 'tier 3',
		'drop_chance' : 27.0,
	},
	{
		'tier_name' : 'tier 4',
		'drop_chance' : 18.0,
	},
	{
		'tier_name' : 'tier 5',
		'drop_chance' : 12.0,
	},
	{
		'tier_name' : 'tier 6',
		'drop_chance' : 8.0,
	},
	{
		'tier_name' : 'tier 7',
		'drop_chance' : 4.0,
	},
	{
		'tier_name' : 'tier 8',
		'drop_chance' : 2.0,
	},
	{
		'tier_name' : 'tier 9',
		'drop_chance' : 1.0
	},
]

func _input(event): # only for manuel use
	if Input.is_action_just_pressed("rng"):
		for i in 100:
			var drop = _generate_drop()
			if !drops.has(drop["tier_name"]):
				drops[drop["tier_name"]] = 0
		
			drops[drop["tier_name"]] += 1
			runs += 1
		_update_drop_diagram()
		print(str(drops))

func _ready():
	for tier in _tiers:
		pool += tier["drop_chance"]
		
	_generate_tier_diagram()
	_generate_drop_diagram()
	

func _update_drop_diagram():
	for drop in drops:
		$DropList.get_node(drop).progress_bar.max_value = runs
		$DropList.get_node(drop).progress_bar.value = drops[drop]
		$DropList.get_node(drop).get_node("HBoxContainer/drops").text = str(drops[drop])

func _get_background_texture(color:Color):
	var img = Image.new()
	img.create(40, 400, true, Image.FORMAT_RGBA8)
	img.fill(color)
	
	var texture = ImageTexture.new()
	texture.create_from_image(img)
	
	return texture

func _generate_tier_diagram():
	for tier_index in _tiers.size():
		var list_item:Tier = load("res://Tier.tscn").instance()
	
		list_item.name = str(tier_index)
		list_item.connect("on_change_chance", self, "_change_chance")
	
		$TierList.add_child(list_item)
	
		list_item.progress_bar.texture_under = _get_background_texture(Color.lightgray)
		list_item.progress_bar.texture_progress = _get_background_texture(Color.lightgreen)
		list_item.progress_bar.max_value = pool
		list_item.progress_bar.value = _tiers[tier_index]["drop_chance"]
	
		list_item.tier_name.text = _tiers[tier_index]["tier_name"]

func _generate_drop_diagram():
	for tier_index in _tiers.size():
		var list_item:Tier = load("res://Tier.tscn").instance()
	
		list_item.name = _tiers[tier_index]["tier_name"]
		list_item.connect("on_change_chance", self, "_change_chance")
	
		$DropList.add_child(list_item)
		
		var drops = Label.new()
		drops.name = "drops"
		drops.align = Label.ALIGN_CENTER
		
		$DropList.get_node(_tiers[tier_index]["tier_name"]).get_node("HBoxContainer").add_child(drops)
		
		list_item.progress_bar.texture_progress = _get_background_texture(Color(255,0,255,.5))
		list_item.tier_name.text = _tiers[tier_index]["tier_name"]
	


func _change_chance(node:String, changes:int):
	pool += changes
	for tier_index in _tiers.size():
		var list_item:Tier = $TierList.get_node(str(tier_index))
		
		list_item.progress_bar.max_value = pool
		
		if(node == str(tier_index)):
			list_item.progress_bar.value += changes

func _generate_drop() -> Dictionary:
	randomize()
	var rng = rand_range(0.0, pool)
	
	for tier in _tiers:
		rng -= tier["drop_chance"]
		if rng < 0:
			return tier
	
	return _tiers[0]
