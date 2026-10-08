extends Resource
##A data type to hold the necessary information for [DebugHandler].
##[br][br]Here's some useful things for your text strings.
##[br][br]@tutorial (Quick Start): How to quickstart.
class_name TextInformation

@export var sprite_to_load: Texture2D = load("res://sample/Horse-a.svg")
@export_multiline() var text := ""

@export var text_speed := 0.05
##@experimental: This does nothing for now.
@export var specialfx : String = ""
##@experimental: It's recommended not to mess with this for now, as it does nothing and it's data type will be changed.
@export var speed_changes: Array = []
#-1 means none
@export var name : String = "Horseton"

@export var metadata : EventMetadataClass = EventMetadataClass.new()

##@experimental: New feature that may be added or removed from FeagueShow.
##[br][br]Input parameters for a function such as a gait, this will not work on null specialfx.
@export var fxarray: Array = []


##Necessary initilization information when calling TextInformation.new().
func _init(spr = load("res://sample/Horse-a.svg"),txt: String = "",speed: float = 0.05, fx: String = "",name : String = "Horseton", fxarr : Array = []) -> void:
	sprite_to_load = spr
	text = txt
	text_speed = speed
	specialfx = fx
	fxarray = fxarr
