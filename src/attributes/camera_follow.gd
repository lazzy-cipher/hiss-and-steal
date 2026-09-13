extends Attribute

static var _count := 0

func _ready() -> void:
	super()

	_count += 1
	assert(_count == 1, "only one CameraFollow is allowed per scene tree")


func initialize(camera: Camera2D) -> void:
	assert(is_instance_valid(camera))

	if not get_entity().is_node_ready():
		await get_entity().ready
	if not camera.is_node_ready():
		await camera.ready

	get_entity().position_changed.connect(camera.set_global_position.unbind(1))
	camera.global_position = get_entity().get_world_position()


func _exit_tree() -> void:
	_count -= 1
	assert(_count == 0, "only one CameraFollow is allowed per scene tree")
