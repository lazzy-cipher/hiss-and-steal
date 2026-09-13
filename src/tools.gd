class_name ToolsClass
extends Node

const ATLAS := preload("res://assets/images/kenney_micro-roguelike/Tilemap/colored_tilemap_packed.png")
const ATLAS_CELL_SIZE := Vector2(8.0, 8.0)

## Wrapper around [code]get_tree().create_timer(time, false).timeout[/code].
func wait(time: float) -> Signal:
	assert(not is_nan(time))
	return get_tree().create_timer(time, false).timeout


## Take a cell from the master atlas ([const ATLAS]) and returns a texture.
func get_sprite(cell: Vector2i) -> AtlasTexture:
	var atlas_texture := AtlasTexture.new()
	atlas_texture.atlas = ATLAS
	atlas_texture.region.size = ATLAS_CELL_SIZE
	atlas_texture.region.position = Vector2(cell) * ATLAS_CELL_SIZE
	return atlas_texture
