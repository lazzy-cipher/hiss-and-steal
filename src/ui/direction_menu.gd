class_name DirectionMenu
extends "res://src/ui/selection_menu.gd"

const ARROW_CELL := Vector2i(3, 6)

func _ready():
	super()

	%Up.payload = Vector2i.UP
	%Down.payload = Vector2i.DOWN
	%Left.payload = Vector2i.LEFT
	%Right.payload = Vector2i.RIGHT
	%UpLeft.payload = Vector2i.UP + Vector2i.LEFT
	%UpRight.payload = Vector2i.UP + Vector2i.RIGHT
	%DownLeft.payload = Vector2i.DOWN + Vector2i.LEFT
	%DownRight.payload = Vector2i.DOWN + Vector2i.RIGHT


func hide_all_directions() -> void:
	for item: MenuItem in _get_menu_items():
		item.hide()


func show_directions(directions: Array[Vector2i]) -> void:
	assert(directions.size() >= 1)

	for dir: Vector2i in directions:
		assert(dir == dir.sign())
		assert(dir != Vector2i.ZERO)

		match dir:
			Vector2i.UP: %Up.show()
			Vector2i.DOWN: %Down.show()
			Vector2i.LEFT: %Left.show()
			Vector2i.RIGHT: %Right.show()
			Vector2i.UP + Vector2i.LEFT: %UpLeft.show()
			Vector2i.UP + Vector2i.RIGHT: %UpRight.show()
			Vector2i.DOWN + Vector2i.LEFT: %DownLeft.show()
			Vector2i.DOWN + Vector2i.RIGHT: %DownRight.show()
			_: assert(false)

	_update_focus()


func _on_item_selected(item: MenuItem) -> void:
	assert(item.payload is Vector2i)
	assert(item.payload == item.payload.sign())
	assert(item.payload != Vector2i.ZERO)
	super(item)
