extends Node2D

var levels = []
var current_level = 0

func _ready():
	var i = 1
	var level_name : String
	while true:
		level_name = "res://levels/Level"+str(i)+".tscn"
		if ResourceLoader.exists(level_name):
			var inst = load(level_name).instance()
			levels.append(inst)
		else:
			break
		i += 1

func delete_children(node):
	for n in node.get_children():
		n.queue_free()

func start():
	levels = []
	_ready()
	delete_children(get_parent().get_node("TempContainer"))
	add_child(levels[current_level])

func exit():
	remove_child(levels[current_level])
	delete_children(get_parent().get_node("TempContainer"))

func next_level():
	current_level += 1
	remove_child(levels[current_level-1])
	add_child(levels[current_level])
	delete_children(get_parent().get_node("TempContainer"))
