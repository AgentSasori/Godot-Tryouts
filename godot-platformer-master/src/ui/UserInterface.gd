extends Control

onready var _scene_tree := get_tree()
onready var _pause_overlay : ColorRect = $PauseOverlay
onready var _label_score : Label = $Label
onready var _label_pause : Label = $PauseOverlay/Title

var paused := false setget set_paused

func _ready():
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	update_interface()

func _on_PlayerData_player_died():
	self.paused = true
	_label_pause.text = "Game Over"

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
#		use "self" keyword to set property via setter
		self.paused = not paused
		
#		stops other unhandled_input functions from been executed
		_scene_tree.set_input_as_handled()

func update_interface():
	_label_score.text = "Score: %s" % PlayerData.get_score()

func set_paused(value: bool):
	paused = value
	_scene_tree.paused = value
	_pause_overlay.visible = value
