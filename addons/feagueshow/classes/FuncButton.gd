extends Button
class_name FuncButton

#@export var function_press_call : String = ""

##Hold the new information to overwrite handler's scene_data if this button is pressed.[br][br]
##Basically, if this button is pressed, all dialog information will be played using this data.
@export var new_scene_data: Array[TextInformation]


func _ready() -> void:
	self.connect("pressed",pass_info)
	
func pass_info() -> void:
	
	%handler.scene_data = new_scene_data
	%handler._hide_options()
	%handler._init_new_text(false)
	%handler.index = 0
	%textbox.modulate = Color(1.0, 1.0, 1.0, 1.0)
	%handler.a.gait = %handler.a.Gaits.NONE
	%handler.a._kill_animations()
	#%textbox.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	#%textbox.offset_transform_scale = Vector2(1.0,1.0)
	
	%handler.end = false
	
	
	#if function_press_call != "":
		#call(function_press_call)
