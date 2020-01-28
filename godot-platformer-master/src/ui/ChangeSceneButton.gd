tool
extends Button

export (String, FILE) var _next_scene_path := ""

func _on_StartButton_pressed():
	get_tree().change_scene(_next_scene_path)

func _get_configuration_warning():
#	if next_scene_path is equal to "" return warning else return empty string
	return "next_scene_path must be set" if _next_scene_path == "" else ""