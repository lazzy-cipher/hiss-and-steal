extends MarginContainer

func async_popup(menu: SelectionMenu) -> void:
	$BaseUI.mouse_behavior_recursive = MOUSE_BEHAVIOR_DISABLED
	$BaseUI.focus_behavior_recursive = FOCUS_BEHAVIOR_DISABLED

	%SelectionMenus.show()

	for m: SelectionMenu in _get_selection_menus():
		m.hide()

	menu.show()
	menu._update_focus()

	await menu.selected

	$BaseUI.mouse_behavior_recursive = MOUSE_BEHAVIOR_INHERITED
	$BaseUI.focus_behavior_recursive = FOCUS_BEHAVIOR_INHERITED
	%SelectionMenus.hide()


func async_popup_entities(
	prompt: String,
	entities: Array[Entity],
	callback: Callable,
	ref_entity_pos: Entity = null,
) -> void:
	assert(entities.size() >= 1)
	assert(callback.is_valid())
	assert(ref_entity_pos == null or is_instance_valid(ref_entity_pos))

	%EntityMenu.clear()
	%EntityMenu.prompt = prompt
	for entity: Entity in entities:
		if ref_entity_pos == null:
			%EntityMenu.add_entity(entity)
			continue
		%EntityMenu.add_entity_surrounding(entity, ref_entity_pos)
	%EntityMenu.selected.connect(callback, CONNECT_ONE_SHOT)
	await async_popup(%EntityMenu)


func async_popup_directions(
	prompt: String,
	directions: Array[Vector2i],
	callback: Callable,
) -> void:
	assert(directions.size() >= 1)
	assert(callback.is_valid())

	%DirectionMenu.hide_all_directions()
	%DirectionMenu.prompt = prompt
	%DirectionMenu.show_directions(directions)
	%DirectionMenu.selected.connect(callback, CONNECT_ONE_SHOT)
	await async_popup(%DirectionMenu)


func _get_selection_menus() -> Array[SelectionMenu]:
	var filter := func(m): return m is SelectionMenu
	return %SelectionMenus.get_children().filter(filter)
