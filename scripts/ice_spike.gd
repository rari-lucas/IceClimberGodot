extends StaticBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()
var isFalling: bool = false

func _ready():
	_stage_variants(GlobalSingleton.currentStage)
	global_position.x = rng.randi_range(-800,800)

func _stage_variants(currentStage):
	match currentStage:
		_:
			pass

func _physics_process(delta):
	if Engine.time_scale == 1:
		if isFalling:
			position.y += 600 * delta
		
		if !isFalling:
			global_position.y = $"../../../Jogador/Camera2D".global_position.y - 510
			global_position.y = $"../../../Jogador/Camera2D".global_position.y - 510
			#global_position.x = $"../../../Jogador".global_position.x

func _on_sprite_animation_finished() -> void:
	isFalling = true
	$Sprite.play("fall")
	$FallSFX.play()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "Deathzone":
		queue_free()
