extends MarginContainer

@onready var entity_menu: EntityMenu = %EntityMenu
@onready var direction_menu: DirectionMenu = %DirectionMenu


func popup(menu: SelectionMenu) -> void:
	$BaseUI.mouse_behavior_recursive = MOUSE_BEHAVIOR_DISABLED
	$BaseUI.focus_behavior_recursive = FOCUS_BEHAVIOR_DISABLED

	%SelectionMenus.show()

	for m: SelectionMenu in _get_selection_menus():
		m.hide()

	menu.show()
	menu.selected.connect(func():
		$BaseUI.mouse_behavior_recursive = MOUSE_BEHAVIOR_INHERITED
		$BaseUI.focus_behavior_recursive = FOCUS_BEHAVIOR_INHERITED
		%SelectionMenus.hide())


func _get_selection_menus() -> Array[SelectionMenu]:
	var filter := func(m): return m is SelectionMenu
	return %SelectionMenus.get_children().filter(filter)
