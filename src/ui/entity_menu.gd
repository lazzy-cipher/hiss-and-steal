class_name EntityMenu
extends "res://src/ui/selection_menu.gd"

const SURROUND_TEXT_FORMAT := "%s (%s)"

var _name_counts := {}

func _ready():
	super()


func clear():
	super()
	_name_counts.clear()


func add_entity(entity: Entity) -> void:
	assert(is_instance_valid(entity))

	var text := entity.entity_name
	_name_counts.set(text, _name_counts.get(text, 0) + 1)
	add_sprite_item(entity.get_sprite_id(), text, entity)


func add_entity_surrounding(entity: Entity, around: Entity) -> void:
	assert(is_instance_valid(entity))
	assert(is_instance_valid(around))
	assert(entity.is_map_position_valid())
	assert(around.is_map_position_valid())
	assert(entity != around)

	var text := entity.entity_name
	var items_with_this_name: int = _name_counts.get(text, 0)
	assert(items_with_this_name >= 0)

	if items_with_this_name == 0:
		add_entity(entity)
		return

	if items_with_this_name == 1:
		for item: MenuItem in _get_menu_items():
			if item.item_name_label.text != text:
				continue

			assert(item.payload is Entity)

			var new_text := SURROUND_TEXT_FORMAT % [
				item.item_name_label.text,
				_get_surround_suffix(item.payload, around),
			]
			item.item_name_label.text = new_text
			break

	text = SURROUND_TEXT_FORMAT % [
		entity.entity_name,
		_get_surround_suffix(entity, around),
	]
	_name_counts.set(text, _name_counts.get(text, 0) + 1)
	add_sprite_item(entity.get_sprite_id(), text, entity)



func _get_surround_suffix(to: Entity, from: Entity) -> String:
	var dir := to.get_map_position() - from.get_map_position()
	dir = dir.sign()

	var suffix: String

	match dir:
		Vector2i.UP: suffix = "Up"
		Vector2i.DOWN: suffix = "Down"
		Vector2i.LEFT: suffix = "Left"
		Vector2i.RIGHT: suffix = "Right"
		Vector2i.UP + Vector2i.LEFT: suffix = "Up Left"
		Vector2i.UP + Vector2i.RIGHT: suffix = "Up Right"
		Vector2i.DOWN + Vector2i.LEFT: suffix = "Down Left"
		Vector2i.DOWN + Vector2i.RIGHT: suffix = "Down Right"
		_: assert(false)

	return suffix
