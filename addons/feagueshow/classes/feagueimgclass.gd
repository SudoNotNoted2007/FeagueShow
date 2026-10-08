extends TextureRect


##[FeagueImgClass] contains useful scripts to animate your characters, these will be called Gaits. [br][br]
##To use a Gait, make sure that you have no active tweens affecting anything in [member Control.offset_transform_scale] and any other similar offset_transform parameters.
##[br][br][color=red]Read documentation carefully, as some things may not work if you change certain properties.[/color]
##[br][br][color=red]Important note! [/color]Scale your character's through their [member Control.custom_maximum_size] or similar. [b]Do not scale by Transform, or by [member Control.offset_transform_scale]![/b]
class_name FeagueImgClass

##@experimental: An unfinished class intended to eventually support multiple on-screen sprites. It's recommended to instead use [DebugHandler] on a Control node as a parent to a Timer.

enum Gaits{NONE,HOP,HOP_CLOSER}

var gait := Gaits.NONE

var pos_store : float = 0.0

var store_old_var : float = 0.0

var current_dir : int = 1

var div_time: float = 0.0

var kill : bool = false

var tween_hop_pos_handle : Tween = create_tween()
var tween_hop_pos_scale : Tween = create_tween()
var tween_pos_rot : Tween = create_tween()

@onready var nameo = %Label

func _ready():
	
	set_process(false)
	pos_store = self.offset_transform_position.x

func _flip_check(dir: int):
	if dir > 0:
		self.flip_h = false
	if dir < 0:
		self.flip_h = true
		
func _kill_animations():
	kill = true
	if tween_hop_pos_handle:
		tween_hop_pos_handle.kill()
		print("killed")
	if tween_hop_pos_scale:
		tween_hop_pos_scale.kill()
	if tween_pos_rot:
		tween_pos_rot.kill()
	kill = false
	offset_transform_position = Vector2.ZERO
	offset_transform_rotation = 0.0
	offset_transform_scale = Vector2(1.0,1.0)

##Hop away, like a horse, or a bunny!
func _hop_away_postgait(direction: int = 1,come_closer: bool = false,time:float = 0.4):
	current_dir = direction
	_flip_check(direction)
	
	if come_closer == false:
		gait = Gaits.HOP
		div_time = time/1.5
	else:
		gait = Gaits.HOP_CLOSER
		div_time = time/1.5
	print("Hop Away Gait")
	if kill == true:
		print("true")
		if tween_hop_pos_handle:
			tween_hop_pos_handle.kill()
			print("killed")
		if tween_hop_pos_scale:
			tween_hop_pos_scale.kill()
		if tween_pos_rot:
			tween_pos_rot.kill()
	tween_hop_pos_handle = create_tween()
	tween_hop_pos_scale = create_tween()
	tween_pos_rot = create_tween()
	
	
	tween_pos_rot.tween_property(self,"offset_transform_rotation",0.15,div_time).set_trans(Tween.TRANS_BACK)
	if gait != Gaits.HOP_CLOSER:
		tween_hop_pos_scale.tween_property(self,"offset_transform_scale",self.offset_transform_scale+Vector2(-0.1,0.1),time).set_trans(Tween.TRANS_BACK)
	#pos_store = pos_store + 200.0
	
	#tween_pos_Store.tween_property(self,"pos_store",store_old_var,time).set_trans(Tween.TRANS_BACK)
	tween_hop_pos_handle.tween_property(self,"offset_transform_position:y",-100.0,time).set_trans(Tween.TRANS_BACK)
	tween_pos_rot.tween_property(self,"offset_transform_rotation",-0.15,div_time).set_trans(Tween.TRANS_BACK)
	print("Up")
	#pos_store = pos_store + 200.0
	tween_hop_pos_handle.tween_property(self,"offset_transform_position:y",0.0,time).set_trans(Tween.TRANS_BACK)
	if gait != Gaits.HOP_CLOSER:
		tween_hop_pos_scale.tween_property(self,"offset_transform_scale",self.offset_transform_scale+Vector2(0.1,-0.1),time).set_trans(Tween.TRANS_BACK)
	tween_hop_pos_handle.set_loops()
	#tween_pos_Store.set_loops()
	tween_pos_rot.set_loops()
	tween_hop_pos_scale.set_loops()


func _physics_process(delta: float) -> void:
	nameo.self_modulate = self_modulate
	if gait == Gaits.HOP:
		#store_old_var += 20.0
		self.offset_transform_position.x = lerp(self.offset_transform_position.x,get_viewport().get_visible_rect().size.x*current_dir,1-exp(-0.2*delta))
	if gait == Gaits.HOP_CLOSER:
		self.offset_transform_scale = lerp(self.offset_transform_scale,Vector2(10.0,10.0),1-exp(-0.1*delta))
		self.self_modulate = lerp(self.self_modulate,Color(0.0, 0.0, 0.0, 0.0),1-exp(-1.5*delta))
