extends Control
##@experimental: May be changed in a future version.
##Not necessarily a class to instantiate, but rather to be used as a script on a Control with a Timer child.
##[br][br] An example of your SceneTree shoud look have a [CanvasLayer] root, with a [Control] child, with another [Control] DebugHandler child.[br][br]
##[color="yellow"]Warning: [/color]Your SceneTree must have a [TextureRect] for character image, and a [PanelContainer] with a [RichTextLabel] child for textbox. [b]All must have Access as Unique Name on, and must be named respectively: debug_image, textbox, and debugger. Turn on Offset Transform in ALL of them.[/b]
class_name DebugHandler

##Holds data using [TextInformation] class.
@export var scene_data: Array[TextInformation] = [
	TextInformation.new(load("res://icon.svg"),"this is a textbox, it's quite amazing, isn't it?\nwhat if the text was [b]bold?[/b]\n[wave amp=50.0 freq=10.0]{wavy?}[/wave]\n[shake]shaking?![/shake]",0.05)
]

@export var index : int = 0
var end : bool = false
var reload_tween

var char_tween = create_tween()
var char_tween_pos = create_tween()
var char_tween_vis = create_tween()

## Initializes important visuals through an animation.
## @experimental: This function may be heavily changed into smaller inits, and image inits may move into the [br]
## [ImageInitClass].
##[br]
## [color=yellow]Warning:[/color] This function must only be called [b]once.[/b] Only call on new characters.
@onready var a = %debug_image
func _init_visuals(time:float = 0.6) -> void:
	
	a.offset_transform_position = Vector2(0.0,50.0)
	a.offset_transform_scale = Vector2(2.0,0.1)
	%textbox.offset_transform_scale = Vector2(0.5,2.5)
	a.self_modulate = Color(0.0,0.0,0.0,0.0)
	%textbox.modulate = a.self_modulate
	
	#TWEENS
	char_tween = create_tween()
	char_tween_pos = create_tween()
	char_tween_vis = create_tween()
	
	var textbox_tween = create_tween()
	var textbox_vis_tween = create_tween()
	
	char_tween_pos.tween_property(a,"offset_transform_position",Vector2.ZERO,time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	char_tween.tween_property(a,"offset_transform_scale",Vector2(1.0,1.0),time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	char_tween_vis.tween_property(a,"self_modulate",Color(1.0, 1.0, 1.0, 1.0),time).set_trans(Tween.TRANS_EXPO)
	textbox_tween.tween_property(%textbox,"offset_transform_scale",Vector2(1.0,1.0),time+0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	textbox_vis_tween.tween_property(%textbox,"modulate",Color(1.0, 1.0, 1.0, 1.0),time+0.25).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_EXPO)
	await textbox_vis_tween.finished
	print("done??")
	char_tween.kill()
	char_tween_pos.kill()
	char_tween_vis.kill()
	textbox_tween.kill()
	textbox_vis_tween.kill()
	$Timer.wait_time = scene_data[0].text_speed
	$Timer.start()
	
	
func _init_new_text(increase_index: bool = true,time : float = 0.6) -> void:
	$Timer.stop()
	if char_tween:
		char_tween.kill()
	if char_tween_vis:
		char_tween_vis.kill()
	if char_tween_pos:
		char_tween_pos.kill()
	a.offset_transform_scale -= Vector2(0.5,-0.5)
	if reload_tween:
		reload_tween.kill()
	
	reload_tween = create_tween()
	reload_tween.tween_property(a,"offset_transform_scale",Vector2(1.0,1.0),time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	if increase_index == true:
		index += 1
	else:
		#intended for text resets
		index = 0
	%debugger.visible_ratio = 0.0
	%debugger.text = str(scene_data[index].text)
	%debug_image.texture = scene_data[index].sprite_to_load
	$Timer.wait_time = scene_data[index].text_speed
	a.nameo.text = scene_data[index].name
	$Timer.start()
	
func _end_interaction(time : float = 0.6) -> void:
	
	
	var ogtextbox_tween = create_tween()
	
	ogtextbox_tween.tween_property(%textbox,"offset_transform_scale",Vector2(0.5,2.5),time/2).set_trans(Tween.TRANS_BACK)
	var textbox_vis_tween = create_tween()
	textbox_vis_tween.tween_property(%textbox,"modulate",Color(0.0, 0.0, 0.0, 0.325),time+0.25).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_EXPO)
	await ogtextbox_tween.finished
	ogtextbox_tween = create_tween()
	
	
	ogtextbox_tween.tween_property(%textbox,"offset_transform_scale",Vector2(1.0,1.0),time/2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	await ogtextbox_tween.finished
	textbox_vis_tween.kill()
	ogtextbox_tween.kill()
	
	
	textbox_vis_tween = create_tween()
	textbox_vis_tween.tween_property(%textbox,"modulate",Color(0.0, 0.0, 0.0, 0.0),time+0.25).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_EXPO)
	var textbox_tween = create_tween()
	
	textbox_tween.tween_property(%textbox,"offset_transform_scale",Vector2(0.0,0.0),time+0.2).set_trans(Tween.TRANS_BACK)
	if scene_data[index].specialfx  != "":
		a.callv(scene_data[index].specialfx, scene_data[index].fxarray)
	show_options()

##@experimental: Values of this function may change in a future release.
##[br]Show an option pop-up.
func show_options(option_amount:int = 2, text_one:String = "Opt 1"):
	var opt_tween = create_tween()
	var opt_vis_tween = create_tween()
	%opt.opt1.text = text_one
	%opt.show()
	%opt.offset_transform_scale = Vector2(0.5,2.0)
	
	opt_vis_tween.tween_property(%opt,"modulate",Color(1.0, 1.0, 1.0, 1.0),0.6).set_trans(Tween.TRANS_BACK)
	opt_tween.tween_property(%opt,"offset_transform_scale",Vector2(1.0,1.0),0.8).set_trans(Tween.TRANS_BACK)
	await opt_tween.finished
	opt_tween.kill()
	opt_vis_tween.kill()
	%opt._enable_buttons()
	
func _hide_options() -> void:
	%opt._disable_buttons()
	var opt_tween = create_tween()
	var opt_vis_tween = create_tween()
	var textbox_scale_tween = create_tween()
	
	#%opt.offset_transform_scale = Vector2(0.5,2.0)
	
	opt_vis_tween.tween_property(%opt,"modulate",Color(0.0, 0.0, 0.0, 0.0),0.6).set_trans(Tween.TRANS_BACK)
	opt_tween.tween_property(%opt,"offset_transform_scale",Vector2(0.0,0.0),0.8).set_trans(Tween.TRANS_BACK)
	textbox_scale_tween.tween_property(%textbox,"offset_transform_scale",Vector2(1.0,1.0),0.8).set_trans(Tween.TRANS_BACK)
	await textbox_scale_tween.finished
	%opt.hide()
	opt_tween.kill()
	opt_vis_tween.kill()
	textbox_scale_tween.kill()
	
	
	
func _process(delta: float) -> void:
	%Label.global_position = lerp(%Label.global_position,a.offset_transform_position+get_viewport().get_visible_rect().size/2,1-exp(-2.5*delta))

func _ready() -> void:
	
	_init_visuals(0.3)
	%debugger.visible_ratio = 0.0
	
	%debugger.text = str(scene_data[0].text)
	%debug_image.texture = scene_data[0].sprite_to_load
	#%debug_image.get_rect().grow(0.5)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("accept") && %debugger.visible_ratio >= 0.99 && %opt.visible == false:
		if index < scene_data.size() - 1:
			_init_new_text()
		elif end == false:
			
			_end_interaction()
			end = true
			#index += 1
	if Input.is_action_just_pressed("accept") && %debugger.visible_ratio <= 0.99:
		$Timer.wait_time = 0.03
	if Input.is_action_just_released("accept"):
		$Timer.wait_time = scene_data[index].text_speed
		


func _on_timer_timeout() -> void:
	if Input.is_action_pressed("accept") && %debugger.visible_ratio <= 0.99:
		%debugger.visible_characters += 2
	else:
		%debugger.visible_characters += 1
	if a.nameo.text == "NAME":
		a.nameo.text = scene_data[index].name
