class_name Entity
extends Node

signal position_changed(new_world_position: Vector2, old_world_position: Vector2)

const TILEMAP_SOURCE_ID := 0
const INVALID_TILE := Vector2i(INT64_MIN, INT64_MIN)

enum SPRITE {
	PLACEHOLDER,
	SNAKE,
	CRAB,
	KEY,
	STAIRS_UP,
	STAIRS_DOWN,
	POTION,
	FIRE,
}

static var sprite_coords := {
	SPRITE.PLACEHOLDER: Vector2i(1, 8),
	SPRITE.SNAKE: Vector2i(4, 1),
	SPRITE.CRAB: Vector2i(12, 0),
	SPRITE.KEY: Vector2i(10, 5),
	SPRITE.STAIRS_UP: Vector2i(5, 3),
	SPRITE.STAIRS_DOWN: Vector2i(4, 3),
	SPRITE.POTION: Vector2i(7, 8),
	SPRITE.FIRE: Vector2i(8, 8),
}

@export var sprite: SPRITE
@export var entity_name := "Unknown Entity"
@export_node_path("Node2D") var spawn_position: NodePath
@export_node_path("TileMapLayer") var walls_tilemap_path: NodePath
@export_node_path("TileMapLayer") var entities_tilemap_path: NodePath

## The position the entity broadcasts to other entities. Not all entities
## broastcast their positions (i.e. held entities, unspawned). Cells can only
## contain one entity.
static var _entity_positions := {}

## The entity's private position. When held, it holds the last position before
## they were picked up.
var _map_position: Vector2i = INVALID_TILE

var _walls_tilemap: TileMapLayer
var _entities_tilemap: TileMapLayer


func _ready() -> void:
	sprite_coords.make_read_only()
	_setup_tilemaps()

	assert(not spawn_position.is_empty())
	var spawn_node_pos: Node2D = get_node(spawn_position)
	assert(is_instance_valid(spawn_node_pos))
	var spawn_point := world_to_map_position(spawn_node_pos.global_position)
	var successfully_spawned := set_map_position(spawn_point)
	assert(successfully_spawned, "invalid spawn point %v" % spawn_point)


func _setup_tilemaps() -> void:
	assert(not walls_tilemap_path.is_empty())
	assert(not entities_tilemap_path.is_empty())

	_walls_tilemap = get_node(walls_tilemap_path)
	_entities_tilemap = get_node(entities_tilemap_path)

	assert(is_instance_valid(_walls_tilemap))
	assert(is_instance_valid(_entities_tilemap))


func get_sprite_id() -> Vector2i:
	return sprite_coords[sprite]


func get_map_position() -> Vector2i:
	return _map_position


func get_world_position() -> Vector2:
	return map_to_world_position(_map_position)


func world_to_map_position(world_pos: Vector2) -> Vector2i:
	if world_pos != world_pos: # nan
		return INVALID_TILE

	var local := _entities_tilemap.to_local(world_pos)
	return _entities_tilemap.local_to_map(local)


func map_to_world_position(map_pos: Vector2i) -> Vector2:
	if map_pos == INVALID_TILE:
		return Vector2(NAN, NAN)

	var new_local_pos := _entities_tilemap.map_to_local(map_pos)
	return _entities_tilemap.to_global(new_local_pos)


## Try to move the sprite to [param new_map_pos]. Return true if the cell is free
## (no entity/wall), and false if it's not. Will only update the position
## internally if the position change succeeded. Update the entity tilemap.
func set_map_position(new_map_pos: Vector2i) -> bool:
	var old_map_pos := _map_position

	if not is_map_position_empty(new_map_pos):
		return _try_slide(new_map_pos - old_map_pos)

	return _set_map_position_internal(new_map_pos, old_map_pos)


func set_map_position_no_sliding(new_map_pos: Vector2i) -> bool:
	var old_map_pos := _map_position
	return _set_map_position_internal(new_map_pos, old_map_pos)


func _set_map_position_internal(new_map_pos: Vector2i, old_map_pos: Vector2i) -> bool:
	_entities_tilemap.erase_cell(old_map_pos)
	_entities_tilemap.set_cell(
		new_map_pos,
		TILEMAP_SOURCE_ID,
		sprite_coords[sprite],
	)

	_map_position = new_map_pos

	_entity_positions.erase(old_map_pos)
	_entity_positions.set(new_map_pos, self)

	position_changed.emit(
		map_to_world_position(new_map_pos),
		map_to_world_position(old_map_pos),
	)

	return true



func _try_slide(dir: Vector2i) -> bool:
	if dir.x == 0 or dir.y == 0:
		return false

	var test_1 := Vector2i(0, dir.y)
	var test_2 := Vector2i(dir.x, 0)

	return set_map_position(_map_position + test_1)\
		or set_map_position(_map_position + test_2)


func is_map_position_empty(map_pos: Vector2i) -> bool:
	return _entities_tilemap.get_cell_source_id(map_pos) == -1\
		and _walls_tilemap.get_cell_source_id(map_pos) == -1


func is_map_position_valid() -> bool:
	return _map_position != INVALID_TILE


func interact(_from: Entity, _interaction := {}) -> void:
	pass


@warning_ignore("unused_parameter")
func request_holding(from: HoldingAttribute) -> bool:
	assert(is_instance_valid(from))
	return from.get_held() != self


static func search_entity(at: Vector2i) -> Entity:
	assert(at != INVALID_TILE)
	return _entity_positions.get(at, null)


static func search_entities_around(entity: Entity) -> Array[Entity]:
	assert(is_instance_valid(entity))
	assert(entity.is_map_position_valid())

	var ret := [] as Array[Entity]

	for dir: Vector2i in Tools.ALL_DIRECTIONS:
		var search_pos := entity.get_map_position() + dir
		var found_entity := search_entity(search_pos)
		if found_entity != null:
			assert(is_instance_valid(found_entity))
			ret.push_back(found_entity)

	return ret


## Returns an array of directions towards empty map positions.
static func search_empty_around(entity: Entity) -> Array[Vector2i]:
	assert(is_instance_valid(entity))
	assert(entity.is_map_position_valid())

	var ret := [] as Array[Vector2i]

	for dir: Vector2i in Tools.ALL_DIRECTIONS:
		var search_pos := entity.get_map_position() + dir
		if entity.is_map_position_empty(search_pos):
			ret.push_back(dir)

	return ret


func remove() -> void:
	_entity_positions.erase(_map_position)
	_entities_tilemap.erase_cell(_map_position)
	_map_position = Entity.INVALID_TILE
