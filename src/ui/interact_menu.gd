extends MarginContainer

const ITEM := preload("res://src/ui/interact_menu_item.tscn")
const MAX_ITEMS := 8


func clear() -> void:
	for child: Node in %InteractContainer.get_children().slice(2):
		child.queue_free()


func add(entity: Entity) -> void:
	assert(%InteractContainer.get_children().slice(2).size() <= MAX_ITEMS - 1)
	
	var item: InteractMenuItem = ITEM.instantiate()
	item.setup(entity)
	%InteractContainer.add_child(item)
	item.selected.connect(_on_item_selected)
	
	_update_focus()


func _update_focus() -> void:
	var items: Array[Node] = %InteractContainer.get_children().slice(2)
	
	if items.size() > 0:
		items[0].grab_focus()
		
	for i: int in items.size():
		var item: InteractMenuItem = items[i]
		
		var next_idx := (i + 1) % items.size()
		var prev_idx := (i - 1) % items.size()
		item.focus_next = items[next_idx].get_path()
		item.focus_previous = items[prev_idx].get_path()
		
		if i > 0:
			item.focus_neighbor_top = items[i - 1].get_path()
		
		if i + 1 < items.size():
			item.focus_neighbor_bottom = items[i + 1].get_path()


func _on_item_selected(item: InteractMenuItem) -> void:
	# TODO
	print_debug(item.get_entity().entity_name)
