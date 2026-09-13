extends MarginContainer

@onready var entity_menu: EntityMenu = %EntityMenu
@onready var direction_menu: DirectionMenu = %DirectionMenu


func hide_all() -> void:
	for menu: SelectionMenu in get_children():
		menu.hide()
		menu.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
		menu.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED


func show_entity_menu() -> void:
	show_menu(entity_menu)


func show_direction_menu() -> void:
	show_menu(direction_menu)


func show_menu(menu: SelectionMenu) -> void:
	assert(is_instance_valid(menu))

	hide_all()
	menu.show()
