class_name DirectionMenu
extends "res://src/ui/selection_menu.gd"

const ARROW_CELL := Vector2i(3, 6)

signal dropped(direction: Direction)

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

func _ready():
	super()

	%Up.payload = Direction.UP
	%Down.payload = Direction.DOWN
	%Left.payload = Direction.LEFT
	%Right.payload = Direction.RIGHT


func hide_all_directions() -> void:
	for item: MenuItem in _get_menu_items():
		item.hide()


func show_up() -> void:
	%Up.show()


func show_down() -> void:
	%Down.show()


func show_left() -> void:
	%Left.show()


func show_right() -> void:
	%Right.show()


func _on_item_selected(item: MenuItem) -> void:
	assert(item.payload is Direction)
	super(item)
	dropped.emit(item.payload)
