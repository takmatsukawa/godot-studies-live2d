extends Control

signal touched

const MIX_RENDER_SIZE := 32
const MAX_RENDER_SIZE := 2048
const RENDER_SIZE_STEP := 256

var pressed: bool = false
var local_pos: Vector2 = Vector2.ZERO
var adjust_pos: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	var vct_resolution = Vector2(get_window().size)        
	var texture_height = floor(vct_resolution.y / RENDER_SIZE_STEP) * RENDER_SIZE_STEP
	texture_height = clampi(texture_height, MIX_RENDER_SIZE, MAX_RENDER_SIZE)
	
	$Sprite2D/GDCubismUserModel.size = Vector2.ONE * texture_height
	
	var vct_viewport_size = Vector2(get_viewport_rect().size)
	$Sprite2D.position = vct_viewport_size / 2
	$Sprite2D.scale.x = vct_viewport_size.y / $Sprite2D/GDCubismUserModel.size.y
	$Sprite2D.scale.y = $Sprite2D.scale.x
	
	if $Sprite2D.centered == true:
		adjust_pos = ($Sprite2D/GDCubismUserModel.size * 0.5)

	if pressed == true:
		$Sprite2D/GDCubismUserModel/GDCubismEffectHitArea.set_target(local_pos)

func _input(event):
	if event as InputEventMouseMotion:
		local_pos = $Sprite2D.to_local(event.position) + adjust_pos

		# マウス座標を表示に使用している Node に変換
		var pos = $Sprite2D.to_local(event.position)
		# 変換した座標を SubViewport の表示サイズに調整
		var render_size: Vector2 = Vector2(
			float($Sprite2D/GDCubismUserModel.size.x) * $Sprite2D.scale.x,
			float($Sprite2D/GDCubismUserModel.size.y) * $Sprite2D.scale.y * -1.0
			) * 0.5
		pos /= render_size
		$Sprite2D/GDCubismUserModel/GDCubismEffectTargetPoint.set_target(pos)
		
	if event as InputEventMouseButton:
		pressed = event.is_pressed()

func _on_gd_cubism_effect_hit_area_hit_area_entered(model: GDCubismUserModel, id: String) -> void:
	touched.emit()
