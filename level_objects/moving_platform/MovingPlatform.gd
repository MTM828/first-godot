extends KinematicBody2D

export var move_speed : int = 1
export (NodePath) var path = NodePath("Path")
var points
var index = 0
var init_pos
var action_frame = 1
var frame = 0

func _ready():
	if path:
		points = get_node(path).curve.get_baked_points()
	init_pos = position

func _physics_process(_delta):
	if !path or frame < action_frame:
		frame += 1
		return
	frame = 0
	var target = points[index]
	position = init_pos + target
	index += move_speed
	if index > points.size() - 1:
		index = 0
