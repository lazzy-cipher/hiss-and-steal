class_name InteractMenuItem
extends MarginContainer

signal selected(item: InteractMenuItem)

const ATLAS := preload("res://assets/images/kenney_micro-roguelike/Tilemap/colored_tilemap_packed.png")
const ATLAS_SIZE := Vector2(8.0, 8.0)

var _entity

func _ready() -> void:
	focus_entered.connect(queue_redraw)
	focus_exited.connect(queue_redraw)


func _gui_input(event: InputEvent) -> void:
	if not has_focus():
		return

	var select := false

	if event.is_action_pressed(&"ui_accept")\
			or event.is_action_pressed(&"ui_select"):
		select = true

	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT\
				and mouse_event.pressed:
			select = true

	if select:
		selected.emit(self)
		accept_event()


func _draw() -> void:
	if has_focus():
		draw_style_box(get_theme_stylebox(&"focus", &"MarginContainer"), Rect2(Vector2.ZERO, size))


func setup(entity: Entity) -> void:
	assert(is_instance_valid(entity))

	var atlas_texture := AtlasTexture.new()
	atlas_texture.atlas = ATLAS
	atlas_texture.region.size = ATLAS_SIZE
	atlas_texture.region.position = Vector2(entity.get_sprite_id()) * ATLAS_SIZE

	%ItemTexture.texture = atlas_texture
	%ItemName.text = entity.entity_name

	_entity = entity


func get_entity() -> Entity:
	return _entity
