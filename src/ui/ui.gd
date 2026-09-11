extends MarginContainer

func show_interact_menu() -> void:
	hide_all()
	%InteractMenu.show()
	%InteractMenu.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED
	%InteractMenu.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED

func hide_all() -> void:
	for menu: Menu in get_children():
		menu.hide()
		menu.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
		menu.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
