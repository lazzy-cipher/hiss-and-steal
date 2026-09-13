class_name MenuItem
extends MarginContainer

signal selected(item: MenuItem)

@onready var item_name_label: Label = %ItemName
@onready var item_texture: TextureRect = %ItemTexture

var payload

var _rotation: int


func _ready() -> void:
	focus_entered.connect(queue_redraw)
	focus_exited.connect(queue_redraw)


@warning_ignore("shadowed_variable")
func setup(texture: Texture2D, text: String, payload: Variant) -> void:
	assert(is_instance_valid(texture))
	if payload is Object and payload != null:
		assert(is_instance_valid(payload))

	item_texture.texture = texture
	item_name_label.text = text

	self.payload = payload


func rotate_image_90_degrees_clockwise() -> void:
	_rotation = (_rotation + 90) % 360
	_show_image_rotation(_rotation)


func rotate_image_90_degrees_counter_clockwise() -> void:
	_rotation = (_rotation + 270) % 360
	_show_image_rotation(_rotation)


func rotate_image_180_degrees() -> void:
	_rotation = (_rotation + 180) % 360
	_show_image_rotation(_rotation)


func _show_image_rotation(image_rotation) -> void:
	assert(_rotation == 0 or _rotation == 90 or _rotation == 180 or _rotation == 270)
	var shader: ShaderMaterial = item_texture.material
	shader.set_shader_parameter(&"rotation", image_rotation)


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
