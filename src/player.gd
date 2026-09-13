class_name Player
extends Entity

@export_node_path("Camera2D") var _camera_path: NodePath
@export_node_path("TileMapLayer") var _held_entities_tilemap_path: NodePath

func _ready():
	super()

	assert(not _camera_path.is_empty())
	assert(not _held_entities_tilemap_path.is_empty())

	%Holding.initialize(get_node(_held_entities_tilemap_path))
	%CameraFollow.initialize(get_node(_camera_path))

	if owner != self and "on_request_holding" in owner:
		%Holding.holding_requested.connect(owner.on_request_holding)
