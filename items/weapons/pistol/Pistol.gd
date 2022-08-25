extends Position2D

var bullet = preload("res://items/ammo/pistol_bullet/PistolBullet.tscn")

export var shoot_cooldown = 2
export var weapon_inaccuracy : float = 0.1
export var aim_speed : float  = 1

var shooting : bool = false
var shot_inaccuracy : float = 0
var rand : RandomNumberGenerator = RandomNumberGenerator.new()

func animation_finished():
	$Animation.play("default")
	$Animation.stop()

func _ready():
	$ShootCooldown.wait_time = shoot_cooldown
	$Animation.play("default")
	var connect_err_code = $Animation.connect("animation_finished", self, "animation_finished", [], CONNECT_DEFERRED)
	if connect_err_code != 0:
		print("Connection error code: ", connect_err_code)

func point_at(target_pos : Vector2, _delta):
	var angle = (target_pos - global_position)
	if angle.x < 1:
		angle *= 1
		$Animation.flip_v = true
	else:
		$Animation.flip_v = false
	var rotation_speed = (PI+aim_speed)*_delta
	angle = angle.angle()
	angle = lerp_angle(global_rotation, angle, aim_speed)
	angle = clamp(angle, global_rotation - rotation_speed, global_rotation + rotation_speed)
	global_rotation = angle

func _process(_delta):
	if $ShootCooldown.time_left > 0:
		pass

func use(target, _delta):
	#point_at(target, _delta)
	point_at(target, 1)
	if not shooting:
		rand.randomize()
		shot_inaccuracy = rand.randf_range(-weapon_inaccuracy, weapon_inaccuracy)
		shooting = true
	rotation += shot_inaccuracy

	if $ShootCooldown.time_left < 1:
		$Animation.play("use")
		var bullet_inst = bullet.instance()
		bullet_inst.rotation = global_rotation
		bullet_inst.position = $BulletStart.global_position
		bullet_inst.sender = get_parent()
		get_tree().get_root().get_node("Main").get_node("TempContainer").add_child(bullet_inst)
		$ShootCooldown.start()
		shooting = false
