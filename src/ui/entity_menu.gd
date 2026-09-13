class_name EntityMenu
extends "res://src/ui/selection_menu.gd"

func _ready():
	super()


func add_entity(entity: Entity) -> void:
	add_sprite_item(entity.get_sprite_id(), entity.entity_name, entity)
