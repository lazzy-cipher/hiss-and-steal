extends Camera2D

func _ready():
	if not owner.is_node_ready():
		await owner.ready

	var tile_maps: Node2D = owner.get_node(^"%TileMaps")
	var limits: Rect2i = tile_maps.get_used_rect()
	limit_left = limits.position.x
	limit_top = limits.position.y
	limit_right = limits.end.x
	limit_bottom = limits.end.y
