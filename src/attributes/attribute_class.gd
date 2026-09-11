class_name Attribute
extends Node

func _ready() -> void:
	var parent := get_parent()
	assert(is_instance_valid(parent), "node must be a child of an Entity")
	assert(parent is Entity, "node must be a child of an Entity")


func get_entity() -> Entity:
	var parent: Entity = get_parent()
	assert(is_instance_valid(parent), "node must be a child of an Entity")
	assert(parent is Entity, "node must be a child of an Entity")

	return parent
