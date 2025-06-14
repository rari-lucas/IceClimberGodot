extends CharacterBody2D

var SPEED = 450.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hurt: bool = false
var hurtTimer: float = 0
var direcao: bool = false

func _ready():
	_stage_variants(GlobalSingleton.currentStage)

func _stage_variants(currentStage):
	match currentStage:
		8:
			SPEED = 1500
		_:
			pass

func _physics_process(_delta):
	if velocity.x >= 0:
		$Sprite.flip_h = 1
	else:
		$Sprite.flip_h = 0 
	
	if direcao == true:
		velocity.x = SPEED * -1
	else:
		velocity.x = SPEED
		
	if (position.x <= -1065):
		position.x = 960
	
	if (position.x >= 1090):
		position.x = -985
	
	move_and_slide()

func _on_timer_timeout() -> void:
	direcao = !direcao
