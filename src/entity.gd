class_name Entity
extends Node

signal position_changed(new_position: Vector2)

const TILEMAP_SOURCE_ID := 0

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

var sprite_coords := {
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
@export_node_path("Node2D") var _spawn_position: NodePath
@export_node_path("TileMapLayer") var _walls_tilemap_path: NodePath
@export_node_path("TileMapLayer") var _entities_tilemap_path: NodePath

var _map_position: Vector2i

var _walls_tilemap: TileMapLayer
var _entities_tilemap: TileMapLayer


func _ready() -> void:
	sprite_coords.make_read_only()
	_setup_tilemaps()
	_spawn()


func _setup_tilemaps() -> void:
	assert(not _walls_tilemap_path.is_empty())
	assert(not _entities_tilemap_path.is_empty())

	_walls_tilemap = get_node(_walls_tilemap_path)
	_entities_tilemap = get_node(_entities_tilemap_path)

	assert(is_instance_valid(_walls_tilemap))
	assert(is_instance_valid(_entities_tilemap))


func _spawn() -> void:
	assert(not _spawn_position.is_empty())
	assert(is_instance_valid(_entities_tilemap),
		"invalid entity tilemap, call _setup_tilemaps() before calling _spawn()")

	var spawn_node_pos: Node2D = get_node(_spawn_position)
	assert(is_instance_valid(spawn_node_pos))
	var local_pos := _entities_tilemap.to_local(spawn_node_pos.global_position)
	var position := _entities_tilemap.local_to_map(local_pos)

	assert(set_map_position(position), "unable to spawn")



func get_map_position() -> Vector2i:
	return _map_position


func get_world_position() -> Vector2:
	var new_local_pos := _entities_tilemap.map_to_local(_map_position)
	return _entities_tilemap.to_global(new_local_pos)


## Try to move the sprite to [param new_map_pos]. Return true if the cell is free
## (no entity/wall), and false if it's not. Will only update the position
## internally if the position change succeeded. Update the entity tilemap.
func set_map_position(new_map_pos: Vector2i) -> bool:
	if _entities_tilemap.get_cell_source_id(new_map_pos) != -1:
		return _try_slide(new_map_pos - _map_position)
	if _walls_tilemap.get_cell_source_id(new_map_pos) != -1:
		return _try_slide(new_map_pos - _map_position)

	_entities_tilemap.erase_cell(_map_position)
	_map_position = new_map_pos
	_entities_tilemap.set_cell(
		new_map_pos,
		TILEMAP_SOURCE_ID,
		sprite_coords[sprite],
	)

	var new_local_pos := _entities_tilemap.map_to_local(new_map_pos)
	var new_global_pos = _entities_tilemap.to_global(new_local_pos)
	position_changed.emit(new_global_pos)

	return true


func _try_slide(dir: Vector2i) -> bool:
	if dir.x == 0 or dir.y == 0:
		return false

	var test_1 := Vector2i(0, dir.y)
	var test_2 := Vector2i(dir.x, 0)

	return set_map_position(_map_position + test_1)\
		or set_map_position(_map_position + test_2)


func interact(_from: Entity, _interaction := {}) -> void:
	pass
