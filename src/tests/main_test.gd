class_name Level
extends Node2D

func _ready():
	%EntitySpawnPositions.queue_free()


func on_request_holding(by: HoldingAttribute) -> void:
	var available_entities: Array[Entity] = Entity.search_around(by.get_entity())
	var remove_unholdable_entities := func(e: Entity): return e.request_holding(by)
	var holdable_entities: Array[Entity] = available_entities.filter(remove_unholdable_entities)

	if holdable_entities.size() < 1:
		return

	if holdable_entities.size() == 1:
		by.hold(holdable_entities[0])
		return

	%UI.entity_menu.clear()
	for entity: Entity in holdable_entities:
		%UI.entity_menu.add_entity_surrounding(entity, %Player)
	var hold := func(m: MenuItem): by.hold(m.payload)
	%UI.entity_menu.selected.connect(hold, CONNECT_ONE_SHOT)
	%UI.popup(%UI.entity_menu)
