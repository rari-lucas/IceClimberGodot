extends Node2D

var startingPos
var maxHeight: float = 0
var maxHeightReached: bool = false
var rng = RandomNumberGenerator.new()
var direcao: int = 0

func _ready() -> void:
	var parentNode = get_parent()
	if (parentNode.tamanhoCelula == true):
		$BrokenBlockSprite.play("bigBlock")
	else:
		$BrokenBlockSprite.play("smallBlock")
	startingPos = parentNode.celulaExport
	global_position = startingPos
	maxHeight = startingPos.y - 150
	direcao = rng.randi_range(0,1)
	if startingPos.y >= 0:
		$BrokenBlockSprite.material.set("shader_parameter/out_c1",Vector4(0,0.31,0,1));
		$BrokenBlockSprite.material.set("shader_parameter/out_c2",Vector4(0.5,0.81,0.06,1));
		$BrokenBlockSprite.material.set("shader_parameter/out_c3",Vector4(1,0.9,0.62,1));
	elif startingPos.y <= -950:
		$BrokenBlockSprite.material.set("shader_parameter/out_c1",Vector4(0.12,0.22,0.94,1));
		$BrokenBlockSprite.material.set("shader_parameter/out_c2",Vector4(0.25,0.75,1,1));
		$BrokenBlockSprite.material.set("shader_parameter/out_c3",Vector4(0.98,0.99,0.99,1));
	else:
		$BrokenBlockSprite.material.set("shader_parameter/out_c1",Vector4(0.5,0.03,0.0,1));
		$BrokenBlockSprite.material.set("shader_parameter/out_c2",Vector4(0.8,0.3,0.06,1));
		$BrokenBlockSprite.material.set("shader_parameter/out_c3",Vector4(1,0.6,0.25,1));

func _physics_process(delta):
	if position.y <= maxHeight:
		maxHeightReached = true
	
	if direcao == 1:
		position.x += -150 * delta
	else:
		position.x += 150 * delta
	
	if maxHeightReached == false:
		position.y += -800 * delta
	else:
		position.y += 1200 * delta


func _on_flip_timer_timeout() -> void:
	if ($BrokenBlockSprite.flip_h == true):
		$BrokenBlockSprite.flip_h = false
	else:
		$BrokenBlockSprite.flip_h = true
