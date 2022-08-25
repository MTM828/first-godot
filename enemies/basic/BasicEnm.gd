extends KinematicBody2D
class_name BasicEnemy

export var acceleration : int = 150
export var deceleration : float = 3
export var jump_power : int = 300
export var detect_dist = 300
export var max_health : int = 50
export var init_health : int = max_health

var moving : bool = false
var vel : Vector2 = Vector2(0, 0)
var health : int = init_health

var Player

func _ready():
	Player = get_parent().get_node("Player")
	$HealthBar.max_value = max_health
	$HealthBar.update_health(health)

func is_within_range(body, dist) -> bool:
	if body.position.distance_to(position) < dist:
		return true
	else:
		return false

func _process(_delta):
	vel.y += Physics.gravity
	moving = false
	if is_within_range(Player, detect_dist):
		if Player.position.x < position.x:
			moving = true
			vel.x = -acceleration
			$Animation.flip_h = true
		elif Player.position.x > position.x:
			moving = true
			vel.x = acceleration
			$Animation.flip_h = false
		if  Player.position.y > position.y + jump_power and is_on_floor():
			vel.y = -jump_power
	if not moving:
		if abs(vel.x) < deceleration:
			vel.x = 0
		elif vel.x < 0:
			vel.x += deceleration
		else:
			vel.x -= deceleration
	if is_within_range(Player, $Knife.use_range):
		$Knife.use()

func hurt(damage):
	health -= damage
	if health <= 0:
		queue_free()
	$HealthBar.update_health(health)

func _physics_process(_delta):
	vel = move_and_slide_with_snap(vel, Vector2.DOWN if is_on_floor() else Vector2.ZERO, Vector2.UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		match collision.collider.name:
			"Ground":
				pass
			"Danger":
				queue_free()
				return
	if is_on_wall():
		vel.x = 0
	if is_on_floor() or is_on_ceiling():
		self.vel.y = 0
