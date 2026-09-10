extends Node2D

func _ready():
	%EntitySpawnPositions.queue_free()

	%Player.position_changed.connect(%Camera.set_global_position)
	%Camera.global_position = %Player.get_world_position()
