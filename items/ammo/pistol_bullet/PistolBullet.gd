extends Area2D
class_name PistolBullet

export var life_duration : int = 200
export var speed : int =  10
export var damage : int = 10
export var weight : float = 0.01

var time_alive : int = 0
var connect_err_code : int
var sender
var gravity_impact : float = 0

func _ready():
	connect_err_code = connect("body_entered", self, "on_body_enter", [], CONNECT_DEFERRED)
	if connect_err_code != 0:
		print("Connection error code: ", connect_err_code)

func _physics_process(_delta):
	gravity_impact += weight
	position += Vector2(speed, 0).rotated(rotation)
	position.y += gravity_impact
	time_alive += 1
	if time_alive > life_duration:
		queue_free()

func on_body_enter(body):
	if body.get_name() == "Ground":
		queue_free()
	elif body.has_method("hurt") and body != sender:
		body.hurt(damage)
		queue_free()
