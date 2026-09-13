class_name SelectionMenu
extends MarginContainer

signal selected(item: MenuItem)

const ITEM := preload("res://src/ui/menu_item.tscn")
const MAX_ITEMS := 8

@export var prompt := "Where?":
	set = set_prompt

func _ready() -> void:
	%Prompt.text = prompt

	for node in _get_menu_items():
		node.selected.connect(_on_item_selected)


func clear() -> void:
	for child: MenuItem in _get_menu_items():
		child.queue_free()


## Wrapper around [method add_item], but show a cell from the master atlas
## ([const ToolsClass.ATLAS]) instead.
func add_sprite_item(cell: Vector2i, text: String, payload: Variant) -> MenuItem:
	return add_item(Tools.get_sprite(cell), text, payload)


func add_item(texture: Texture2D, text: String, payload: Variant) -> MenuItem:
	assert(is_instance_valid(texture))
	if payload is Object and payload != null:
		assert(is_instance_valid(payload))
	assert(_get_menu_items().size() <= MAX_ITEMS - 1)

	var item: MenuItem = ITEM.instantiate()
	item.setup(texture, text, payload)
	%SelectionContainer.add_child(item)
	item.selected.connect(_on_item_selected)

	_update_focus()

	return item


func set_prompt(p: String) -> void:
	prompt = p


func _update_focus() -> void:
	var items: Array[MenuItem] = _get_menu_items()

	if items.size() > 0:
		items[0].grab_focus()

	for i: int in items.size():
		var item: MenuItem = items[i]

		var next_idx := (i + 1) % items.size()
		var prev_idx := (i - 1) % items.size()
		item.focus_next = items[next_idx].get_path()
		item.focus_previous = items[prev_idx].get_path()

		if i > 0:
			item.focus_neighbor_top = items[i - 1].get_path()

		if i + 1 < items.size():
			item.focus_neighbor_bottom = items[i + 1].get_path()


func _get_menu_items() -> Array[MenuItem]:
	assert(%SelectionContainer.get_children().size() >= 2)
	return %SelectionContainer.get_children().slice(2)


func _on_item_selected(item: MenuItem) -> void:
	selected.emit(item)
