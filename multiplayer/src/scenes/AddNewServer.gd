extends Popup

signal on_cancel_pressed
signal on_save_pressed

func _on_cancel_pressed():
	emit_signal("on_cancel_pressed")


func _on_save_pressed():
	emit_signal("on_save_pressed")
