extends CharacterBody2D

var SPEED = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hurt: bool = false
var hurtTimer: float = 0
var direcao: bool = false
var testeSpawn: bool = false
var isP2 = ""

func _ready():
	_stage_variants(GlobalSingleton.currentStage)

func _stage_variants(currentStage):
	match currentStage:
		3:
			isP2 = "2"
		8:
			SPEED = randi_range(100,500)
		_:
			pass

func _physics_process(delta):
	if testeSpawn == false:
		_direcao_apos_spawn()
	
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

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "Martelo":
		hurt = true
		SPEED = SPEED/2
		if area.get_parent().name.contains("2"):
			GlobalSingleton._add_score("topi2")
		else:
			GlobalSingleton._add_score("topi")
		$Sprite.play("death")
		$DeathSFX.play()
		$Hitbox.set_collision_layer_value(5,false)
		$Hurtbox.set_collision_mask_value(4,false)
	elif area.name == "Deathzone":
		queue_free()

func _direcao_apos_spawn():
	if position.x > 0:
		direcao = true
	testeSpawn = true
