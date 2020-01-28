extends Node

signal score_updated
signal player_died

var _score := 0 setget set_score, get_score
var _deaths := 0 setget set_deaths, get_deaths

func set_score(score : int):
	_score = score
	emit_signal("score_updated")
	
func get_score() -> int:
	return _score
	
func set_deaths(deaths : int):
	_deaths = deaths
	emit_signal("player_died")
	
func get_deaths() -> int:
	return _deaths
	
func reset():
	_score = 0
	_deaths = 0