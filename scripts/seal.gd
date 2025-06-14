extends CharacterBody2D

var SPEED = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hurt: bool = false
var hurtTimer: float = 0
var direcao: bool = false

func _ready():
	_stage_variants(GlobalSingleton.currentStage)
	direcao = $"../../../Jogador/Sprite".flip_h

func _stage_variants(currentStage):
	match currentStage:
		_:
			pass

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.x > 0:
		$Sprite.flip_h = 1
	
	if is_on_floor():
		if direcao == true:
			velocity.x = SPEED * -1
		else:
			velocity.x = SPEED
		
	if hurt == true:
		hurtTimer += delta
		if direcao == true:
			velocity.x = SPEED
		else:
			velocity.x = SPEED * -1
		if hurtTimer >= 0.5:
			$Sprite.scale.x = $Sprite.scale.x * -1
			hurtTimer = 0
	
	move_and_slide()

func _on_martelo_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		hurt = true
		SPEED = SPEED/2
		$Sprite.play("death")
		$Martelo.set_collision_layer_value(4,false)
		$Martelo.set_collision_mask_value(3,false)
	if area.name == "Deathzone":
		$"../../../Jogador".seelCount += -1
		queue_free()
