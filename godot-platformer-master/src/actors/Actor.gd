extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL := Vector2.UP

export var _speed := Vector2(300, 1500)
export var _gravity := 3000.0

var _velocity := Vector2.ZERO