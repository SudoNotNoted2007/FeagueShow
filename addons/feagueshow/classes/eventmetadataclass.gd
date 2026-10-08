extends Resource
##Holds additional information for the handler to look at, such as option pop-ups.
class_name EventMetadataClass

##Show an option array. An empty array will use placeholder option names. Put in 2 names for the text_one and text_two parameter of [method DebugHandler.show_options]
@export var show_options_data : Array[String] = []

##If choosing option1, set the [member FuncButton.new_scene_data].
@export var option1_scene_data : TextInformation
