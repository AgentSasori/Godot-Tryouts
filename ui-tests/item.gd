extends TextureRect

var itemIcon
var itemName
var itemValue
var itemSlot
var slotType
var itemScene
var picked = false

func _init(_itemName, _itemTexture, _itemSlot, _itemValue, _slotType, _itemScene):
	self.itemName = _itemName
	self.itemValue = _itemValue
	self.itemSlot = _itemSlot
	self.slotType = _slotType
	self.itemScene = _itemScene
	texture = _itemTexture
