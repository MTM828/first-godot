extends Area2D
class_name LevelPortal

var connect_err_code : int

func _ready():
	connect_err_code = connect("body_entered", self, "on_body_enter", [], CONNECT_DEFERRED)
	if connect_err_code != 0:
		print("Connection error code: ", connect_err_code)

func on_body_enter(body):
	if body.has_method("respawn"):
		body.respawn()
		get_tree().get_root().get_node("Main").get_node("LevelLoader").next_level()
