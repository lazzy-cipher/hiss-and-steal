class_name Player
extends Entity

const WALKING_SPEED := 10.0 # tile per second
const RUNNING_SPEED := 20.0 # tile per second


var _dir: Vector2

func _ready():
	super()


func _process(_delta: float) -> void:
	_movement()


func _movement() -> void:
	_update_movement_speed()

	var new_dir := Input.get_vector(&"left", &"right", &"up", &"down")
	var is_just_pressed = (new_dir.x != 0.0 and new_dir.x != _dir.x)\
		or (new_dir.y != 0.0 and new_dir.y != _dir.y)
	_dir = new_dir

	if new_dir != Vector2.ZERO and not %MovementCooldown.timeout.is_connected(_move):
		%MovementCooldown.timeout.connect(_move)
	elif new_dir == Vector2.ZERO and %MovementCooldown.timeout.is_connected(_move):
		%MovementCooldown.timeout.disconnect(_move)

	%MovementCooldown.one_shot = _dir == Vector2.ZERO

	if is_just_pressed and %MovementCooldown.is_stopped():
		%MovementCooldown.timeout.emit()
		%MovementCooldown.start()


func _update_movement_speed():
	var is_running := Input.is_action_pressed(&"run")
	var speed = 1.0 / (RUNNING_SPEED if is_running else WALKING_SPEED)
	%MovementCooldown.wait_time = speed


func _move() -> void:
	var dir := Vector2i(_dir.normalized().round())
	set_map_position(get_map_position() + dir)
