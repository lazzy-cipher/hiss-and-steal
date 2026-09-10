class_name Player
extends Entity

const WALKING_SPEED := 10.0 # tile per second
const RUNNING_SPEED := 20.0 # tile per second
const HELD_POSITION := Vector2i.UP

@export_node_path("TileMapLayer") var _held_entities_tilemap_path: NodePath

var _dir: Vector2
var _held: Entity
var _held_entities_tilemap: TileMapLayer

func _ready():
	super()


func _setup_tilemaps() -> void:
	super()
	
	assert(not _held_entities_tilemap_path.is_empty())
	_held_entities_tilemap = get_node(_held_entities_tilemap_path)
	assert(is_instance_valid(_held_entities_tilemap))


func hold(entity: Entity) -> void:
	# TODO: "disable" held entity
	assert(is_instance_valid(entity))
	
	var new_held_map_pos := get_map_position() + HELD_POSITION
	var old_held_map_pos := entity.get_map_position()
	
	_held = entity
	_held._map_position = new_held_map_pos
	_held_entities_tilemap.set_cell(
		new_held_map_pos,
		TILEMAP_SOURCE_ID,
		entity.get_sprite_id(),
	)
	_held_entities_tilemap.erase_cell(old_held_map_pos)


func set_map_position(new_map_pos: Vector2i) -> bool:
	var old_held_map_pos := get_map_position() + HELD_POSITION
	
	var moved := super(new_map_pos)
	
	if moved and is_instance_valid(_held):
		var new_held_map_pos := get_map_position() + HELD_POSITION
		
		_held_entities_tilemap.erase_cell(old_held_map_pos)
		_held_entities_tilemap.set_cell(
			new_held_map_pos,
			TILEMAP_SOURCE_ID,
			_held.get_sprite_id(),
		)
		_held._map_position = new_held_map_pos
	
	return moved


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
	var speed = 1.0 / (RUNNING_SPEED if is_running else WALKING_SPEED)
	%MovementCooldown.wait_time = speed


func _move() -> void:
	var dir := Vector2i(_dir.normalized().round())
	set_map_position(get_map_position() + dir)
