extends Sprite2D

signal touched

const MIX_RENDER_SIZE := 32
const MAX_RENDER_SIZE := 2048
const RENDER_SIZE_STEP := 256

var pressed: bool = false
var local_pos: Vector2 = Vector2.ZERO
var adjust_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	var dict_motion = $GDCubismUserModel.get_motions()
	for k in dict_motion:
		for v in range(dict_motion[k]):
			print("mao motion: k: %s v: %s " % [k, v])	
			
	for item in $GDCubismUserModel.get_expressions():
		print("mao expression: %s" % item)

			
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	var vct_resolution = Vector2(get_window().size)        
	var texture_height = floor(vct_resolution.y / RENDER_SIZE_STEP) * RENDER_SIZE_STEP
	texture_height = clampi(texture_height, MIX_RENDER_SIZE, MAX_RENDER_SIZE)
	
	$GDCubismUserModel.size = Vector2.ONE * texture_height
	
	var vct_viewport_size = Vector2(get_viewport_rect().size)
	#position = vct_viewport_size / 2
	scale.x = vct_viewport_size.y / $GDCubismUserModel.size.y
	scale.y = scale.x
	
	if centered == true:
		adjust_pos = ($GDCubismUserModel.size * 0.5)

	if pressed == true:
		$GDCubismUserModel/GDCubismEffectHitArea.set_target(local_pos)

func _input(event):
	if event as InputEventMouseMotion:
		local_pos = to_local(event.position) + adjust_pos

		# マウス座標を表示に使用している Node に変換
		var pos = to_local(event.position)
		# 変換した座標を SubViewport の表示サイズに調整
		var render_size: Vector2 = Vector2(
			float($GDCubismUserModel.size.x) * scale.x,
			float($GDCubismUserModel.size.y) * scale.y * -1.0
			) * 0.5
		pos /= render_size
		$GDCubismUserModel/GDCubismEffectTargetPoint.set_target(pos)
		
	if event as InputEventMouseButton:
		pressed = event.is_pressed()

func _on_gd_cubism_effect_hit_area_hit_area_entered(model: GDCubismUserModel, id: String) -> void:
	touched.emit()

func start_angry() -> void:
	$StateChart.send_event("made_her_angry")

func start_happy() -> void:
	$StateChart.send_event("made_her_happy")


func _on_idle_state_entered() -> void:
	$GDCubismUserModel.start_motion("", 1, GDCubismUserModel.PRIORITY_FORCE)
	$GDCubismUserModel.start_expression("exp_01")

func _on_angry_state_entered() -> void:
	$GDCubismUserModel.start_motion("Idle", 0, GDCubismUserModel.PRIORITY_FORCE)
	$GDCubismUserModel.start_expression("exp_08")

func _on_happy_state_entered() -> void:
	$GDCubismUserModel.start_motion("", 0, GDCubismUserModel.PRIORITY_FORCE)
	$GDCubismUserModel.start_expression("exp_04")
