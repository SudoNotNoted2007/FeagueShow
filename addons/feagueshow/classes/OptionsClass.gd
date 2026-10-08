extends VBoxContainer
class_name OptionsClass

@onready var opt1 = $Button
@onready var opt2 = $Button2

func _enable_buttons() -> void:
	opt1.disabled = false
	opt2.disabled = false
	
func _disable_buttons() -> void:
	opt1.disabled = true
	opt2.disabled = true
