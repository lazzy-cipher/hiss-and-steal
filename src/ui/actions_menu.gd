class_name ActionMenu
extends MarginContainer

const TAKE_TEXT := "(%s) Take"
const TALK_TEXT := "(%s) Talk"
const INSPECT_TEXT := "(%s) Inspect"
const KISS_TEXT := "(%s) Kiss"
const OROBOROS_TEXT := "(%s) Oroboros"

func _ready():
	_update_input_labels()


func _update_input_labels() -> void:
	var take_event := InputMap.action_get_events(&"take")[0]
	var talk_event := InputMap.action_get_events(&"talk")[0]
	var inspect_event := InputMap.action_get_events(&"inspect")[0]
	var kiss_event := InputMap.action_get_events(&"kiss")[0]
	var oroboros_event := InputMap.action_get_events(&"oroboros")[0]

	var take_text := take_event.as_text().to_upper().rstrip(" - PHYSICAL")
	var talk_text := talk_event.as_text().to_upper().rstrip(" - PHYSICAL")
	var inspect_text := inspect_event.as_text().to_upper().rstrip(" - PHYSICAL")
	var kiss_text := kiss_event.as_text().to_upper().rstrip(" - PHYSICAL")
	var oroboros_text := oroboros_event.as_text().to_upper().rstrip(" - PHYSICAL")

	%TakeMenuItem.item_name_label.text = %TakeMenuItem.item_name_label.text % take_text
	%TalkMenuItem.item_name_label.text = %TalkMenuItem.item_name_label.text % talk_text
	%InspectMenuItem.item_name_label.text = %InspectMenuItem.item_name_label.text % inspect_text
	%KissMenuItem.item_name_label.text = %KissMenuItem.item_name_label.text % kiss_text
	%OroborosMenuItem.item_name_label.text = %OroborosMenuItem.item_name_label.text % oroboros_text
