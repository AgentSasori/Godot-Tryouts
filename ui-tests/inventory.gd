extends Control

#const ItemClass = preload("res://item.gd")
#const ItemSlotClass = preload("res://itemslot.gd")

#var inv = [itemlist.items[0]]



func _on_Area2D_body_entered(body):
	self.visible = true

func _on_Area2D_body_exited(body):
	self.visible = false
