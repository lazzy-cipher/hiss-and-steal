extends Node2D

func _ready():
	assert(position == Vector2.ZERO)
	assert(get_child_count() > 0)
	for node: Node in get_children():
		assert(node is TileMapLayer)
		assert(node.position == Vector2.ZERO)


func get_used_rect() -> Rect2i:
	var maps: Array[TileMapLayer] = Array(get_children(), TYPE_OBJECT, &"TileMapLayer", null)
	var rect_i:= maps[0].get_used_rect()

	for map: TileMapLayer in maps.slice(1):
		rect_i = rect_i.merge(map.get_used_rect())

	var pos := maps[0].map_to_local(rect_i.position)
	var size := maps[0].map_to_local(rect_i.size)

	# map_to_local returns the center of the cell, we want top left
	var tile_size := Vector2i(maps[0].tile_set.tile_size)
	pos -= tile_size / 2.0
	size -= tile_size / 2.0

	return Rect2i(pos, size)
