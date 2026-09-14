class_name HoldingAttribute
extends Attribute

signal holding_requested(from: HoldingAttribute)
signal dropping_requested(from: HoldingAttribute)

const HELD_POSITION := Vector2i.UP

var _held: Entity:
	get = get_held,
	set = set_held
var _held_entities_tilemap: TileMapLayer

func _ready():
	super()


func initialize(held_entities_tilemap: TileMapLayer) -> void:
	assert(is_instance_valid(held_entities_tilemap))
	_held_entities_tilemap = held_entities_tilemap
	get_entity().position_changed.connect(_move_held)


func hold(entity: Entity) -> void:
	assert(is_instance_valid(_held_entities_tilemap),
		"run initialize() before using the attribute")
	assert(is_instance_valid(entity))
	assert(_held == null,
		"holding two items is not a supported feature, yet")

	var new_held_map_pos: Vector2i = get_entity().get_map_position() + HELD_POSITION

	_held = entity
	entity.remove()
	_held_entities_tilemap.set_cell(
		new_held_map_pos,
		Entity.TILEMAP_SOURCE_ID,
		entity.get_sprite_id(),
	)


func drop(at: Vector2i) -> void:
	assert(_held != null)
	assert(at != Entity.INVALID_TILE)

	assert(_held.set_map_position_no_sliding(at))
	_held = null

	var old_map_pos := get_entity().get_map_position() + HELD_POSITION
	_held_entities_tilemap.erase_cell(old_map_pos)


func get_held() -> Entity:
	assert(_held == null or is_instance_valid(_held))
	return _held


func set_held(e: Entity) -> void:
	assert(_held == null or is_instance_valid(_held))
	_held = e


func _move_held(new_world_position: Vector2, old_world_position: Vector2) -> void:
	assert(is_instance_valid(_held_entities_tilemap),
		"run initialize() before using the attribute")
	if _held == null:
		return
	assert(not _held.is_map_position_valid())

	var new_map_position := get_entity().world_to_map_position(new_world_position)
	var old_map_position := get_entity().world_to_map_position(old_world_position)

	var new_held_map_pos := new_map_position + HELD_POSITION
	var old_held_map_pos := old_map_position + HELD_POSITION

	_held_entities_tilemap.erase_cell(old_held_map_pos)
	_held_entities_tilemap.set_cell(
		new_held_map_pos,
		Entity.TILEMAP_SOURCE_ID,
		_held.get_sprite_id(),
	)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"take"):
		if _held == null:
			holding_requested.emit(self)
		else:
			dropping_requested.emit(self)
