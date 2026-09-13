class_name Level
extends Node2D

func _ready():
	%EntitySpawnPositions.queue_free()


func on_request_holding(by: Entity) -> void:
	var available_entities := Entity.search_around(by)
	# TODO: do a popup, make sure if there are duplicate entities to mark
	# them as up or down
