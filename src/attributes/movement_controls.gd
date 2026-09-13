extends Attribute

var walking_speed := 10.0 # tile per second
var running_speed := 20.0 # tile per second

var _dir: Vector2

func _ready() -> void:
	super()


func _process(_delta: float) -> void:
	_process_movement()


func _process_movement() -> void:
	_process_movement_speed()

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


func _process_movement_speed():
	var is_running := Input.is_action_pressed(&"run")
	var speed = 1.0 / (running_speed if is_running else walking_speed)
	%MovementCooldown.wait_time = speed


func _move() -> void:
	var dir := Vector2i(_dir.normalized().round())
	get_entity().set_map_position(get_entity().get_map_position() + dir)
