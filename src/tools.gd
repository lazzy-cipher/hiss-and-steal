extends Node

func wait(time: float) -> Signal:
	assert(not is_nan(time))
	return get_tree().create_timer(time, false).timeout
