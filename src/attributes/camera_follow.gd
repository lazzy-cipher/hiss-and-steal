extends Attribute

@export_node_path("Camera2D") var _camera_path: NodePath
var _camera: Camera2D

static var _count := 0

func _ready() -> void:
	super()

	_count += 1
	assert(_count == 1, "only one CameraFollow is allowed per scene tree")

	assert(not _camera_path.is_empty(), "must be given a Camera2D to follow")
	_camera = get_node(_camera_path)
	assert(is_instance_valid(_camera))

	if not get_entity().is_node_ready():
		await get_entity().ready
	if not _camera.is_node_ready():
		await _camera.ready

	get_entity().position_changed.connect(_camera.set_global_position.unbind(1))
	_camera.global_position = get_entity().get_world_position()


func _exit_tree() -> void:
	_count -= 1
	assert(_count == 0, "only one CameraFollow is allowed per scene tree")
