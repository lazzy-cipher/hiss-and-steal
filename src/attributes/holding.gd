extends Attribute

const HELD_POSITION := Vector2i.UP

@export_node_path("TileMapLayer") var _held_entities_tilemap_path: NodePath

var _held: Entity
var _held_entities_tilemap: TileMapLayer

func _ready():
	super()

	assert(not _held_entities_tilemap_path.is_empty())
	_held_entities_tilemap = get_node(_held_entities_tilemap_path)
	assert(is_instance_valid(_held_entities_tilemap))

	get_entity().position_changed.connect(_move_held)


func hold(entity: Entity) -> void:
	assert(is_instance_valid(entity))
	assert(not is_instance_valid(_held), "holding two items is not a supported feature, yet")

	var new_held_map_pos: Vector2i = get_entity().get_map_position() + HELD_POSITION
	var old_map_pos := entity.get_map_position()

	_held = entity
	_held._map_position = new_held_map_pos
	_held_entities_tilemap.set_cell(
		new_held_map_pos,
		Entity.TILEMAP_SOURCE_ID,
		entity.get_sprite_id(),
	)
	entity._entities_tilemap.erase_cell(old_map_pos)


func _move_held(new_world_position: Vector2, old_world_position: Vector2) -> void:
	if not is_instance_valid(_held):
		return

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
	_held._map_position = new_held_map_pos
