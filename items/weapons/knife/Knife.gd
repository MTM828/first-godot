extends Area2D
class_name Knife

export var attack_cooldown = 0.2
export var damage : int = 1
export var use_range = 40
export var use_agility = 10

var use_pos : Vector2 = Vector2(0, 0)
var use_max_pos : Vector2 = Vector2(use_range, 0)
var direction = 1
var using = false

var connect_err_code : int

func use():
	use_pos.x += use_agility
	if use_pos > use_max_pos:
		use_pos = Vector2(0, 0)
		using = false

func _ready():
	$AttackCooldown.wait_time = attack_cooldown
	connect_err_code = connect("body_entered", self, "on_body_enter", [], CONNECT_DEFERRED)
	if connect_err_code != 0:
		print("Connection error code: ", connect_err_code)

func _physics_process(_delta):
	position = Vector2(0, 0)
	if get_parent().get_node("Animation").flip_h == true:
		direction = -1
		$Animation.flip_h = true
	else:
		direction = 1
		$Animation.flip_h = false
	position += use_pos * direction

func on_body_enter(body):
	if body.has_method("hurt") and body != get_parent():
		body.hurt(damage)
