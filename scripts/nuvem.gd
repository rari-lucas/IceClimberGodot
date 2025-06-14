extends CharacterBody2D
var SPEED: float = 300
var resetPos: bool = false

func _ready():
	_stage_variants(GlobalSingleton.currentStage)

func _stage_variants(currentStage):
	match currentStage:
		5:
			resetPos = true
		8:
			SPEED = 600
		_:
			pass

func _physics_process(_delta):
	velocity.x = SPEED * -1
	
	if (position.x <= -1065):
		position.x = 960
	if (position.x >= 1090):
		position.x = -985
	
	move_and_slide()


func _on_jogador_spawn_bonus_veggie() -> void:
	if resetPos == true: 
		if name.contains("2"):
			position = Vector2(-289,-3062)
		else:
			position = Vector2(599,-2530)
