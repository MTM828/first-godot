extends KinematicBody2D
class_name Player

var score : int = 0

export var acceleration : int = 30
export var deceleration : int = 10
export var acceleration_over_max : float = 0.1
export var acceleration_in_air : int = -10
export var top_speed : int = 200
export var jump_power : float = 400
export var jump_hold_power : float = 2
export var air_jump_power : float = 400
export var max_jumps : int = 2
export var leap_power : Vector2 = Vector2(700, 350)
export var leap_disable_air_jump : bool = true
export var max_health : int = 100
export var init_health : int = max_health

var moving : bool = false
var current_jump : int = 0
var let_go_of_jump : bool = false
var vel : Vector2 = Vector2(0, 0)
var health : int = init_health

func _ready():
	$UI/HealthBar.max_value = max_health
	$UI/HealthBar.update_health(health)

func play_animation(animation_name):
	if not $Animation.animation == animation_name:
		$Animation.play(animation_name)

func _process(_delta):
	if Input.is_mouse_button_pressed(1):
		$Weapon.use(get_global_mouse_position(), _delta)

	vel.y += Physics.gravity
	
	if not moving:
		if abs(vel.x) < deceleration:
			vel.x = 0
		elif vel.x < 0:
			vel.x += deceleration
		else:
			vel.x -= deceleration

	moving = false
	if Input.is_action_pressed("move_left"):
		moving = true
		if not vel.x <= -top_speed:
			vel.x -= acceleration
		else:
			vel.x -= acceleration_over_max
		if not is_on_floor():
			if vel.x > 0:
				vel.x += acceleration_in_air
			else:
				vel.x -= acceleration_in_air
	elif Input.is_action_pressed("move_right"):
		moving = true
		if not vel.x >= top_speed:
			vel.x += acceleration
		else:
			vel.x += acceleration_over_max
		if not is_on_floor():
			if vel.x > 0:
				vel.x += acceleration_in_air
			else:
				vel.x -= acceleration_in_air

	if Input.is_action_pressed("move_left"):
		play_animation("walk")
		$Animation.flip_h = true
		if not vel.x <= -top_speed:
			vel.x -= acceleration
		else:
			vel.x -= acceleration_over_max
		if vel.y < 1:
			play_animation("jump")
		elif vel.y > Physics.gravity:
			play_animation("fall")
	elif Input.is_action_pressed("move_right"):
		play_animation("walk")
		$Animation.flip_h = false
		if not vel.x >= top_speed:
			vel.x += acceleration
		else:
			vel.x += acceleration_over_max
		if vel.y < 1:
			play_animation("jump")
		elif vel.y > Physics.gravity:
			play_animation("fall")
	else:
		play_animation("idle")
		if vel.y < 1:
			play_animation("jump")
		elif vel.y > Physics.gravity:
			play_animation("fall")

func leap():
	if Input.is_action_pressed("jump") and is_on_floor() and let_go_of_jump:
		if Input.is_action_pressed("move_left"):
			vel = Vector2(-leap_power.x, -leap_power.y)
		elif Input.is_action_pressed("move_right"):
			vel = Vector2(leap_power.x, -leap_power.y)
		if leap_disable_air_jump:
			current_jump = max_jumps
		let_go_of_jump = false

func respawn():
	position = Vector2(0, 0)
	vel = Vector2(0, 0)
	current_jump = max_jumps

func hurt(damage):
	health -= damage
	if health < 1:
		respawn()
		health = max_health
	$UI/HealthBar.update_health(health)

func _physics_process(_delta):
	leap()
	vel = move_and_slide_with_snap(vel, Vector2.DOWN if is_on_floor() else Vector2.ZERO, Vector2.UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		match collision.collider.name:
			"Ground":
				pass
			"Danger":
				respawn()
				return
			"Portal":
				respawn()
				get_tree().get_root().get_node("Main").next_level()
		if collision.collider is BasicEnemy:
			respawn()
			return

	if not Input.is_action_pressed("jump"):
		let_go_of_jump = true
	else:
		vel.y -= jump_hold_power
	if not is_on_floor():
		if Input.is_action_pressed("jump") and current_jump < max_jumps and let_go_of_jump:
			vel.y = -air_jump_power
			current_jump += 1
			let_go_of_jump = false
	else:
		if Input.is_action_pressed("jump"):
			vel.y = -air_jump_power
			current_jump = 1
			let_go_of_jump = false
		else:
			vel.y = 0
			current_jump = 1
	if is_on_wall():
		vel.x = 0
	if is_on_ceiling():
		vel.y = 0
