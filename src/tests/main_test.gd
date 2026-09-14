class_name Level
extends Node2D

func _ready():
	%EntitySpawnPositions.queue_free()


func on_request_holding(by: HoldingAttribute) -> void:
	var available_entities: Array[Entity] = Entity.search_entities_around(by.get_entity())
	var remove_unholdable_entities := func(e: Entity): return e.request_holding(by)
	var holdable_entities: Array[Entity] = available_entities.filter(remove_unholdable_entities)

	# Nothing to hold
	if holdable_entities.size() < 1:
		return

	# Only one thing to hold, no prompt
	if holdable_entities.size() == 1:
		by.hold(holdable_entities[0])
		return

	# Player needs to choose what to hold, menu prompt
	var hold := func(m: MenuItem): by.hold(m.payload)
	$Entities.process_mode = Node.PROCESS_MODE_DISABLED
	await %UI.async_popup_entities("What to take?", holdable_entities, hold, %Player)
	$Entities.process_mode = Node.PROCESS_MODE_INHERIT


func on_request_dropping(by: HoldingAttribute) -> void:
	var droppable_map_pos := Entity.search_empty_around(by.get_entity())

	# Nowhere to drop
	if droppable_map_pos.size() < 1:
		return

	# Only one place to drop, no prompt
	if droppable_map_pos.size() == 1:
		by.drop(droppable_map_pos[0])
		return

	# Player needs to where to drop, menu prompt
	var drop := func(m: MenuItem):
		by.drop(by.get_entity().get_map_position() + m.payload)

	$Entities.process_mode = Node.PROCESS_MODE_DISABLED
	await %UI.async_popup_directions("Where to drop?", droppable_map_pos, drop)
	$Entities.process_mode = Node.PROCESS_MODE_INHERIT
