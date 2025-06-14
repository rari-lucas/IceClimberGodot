extends Camera2D
var allowSwap: bool = false
var hasSwapped: bool = false
var parentNode

func _ready():
	_stage_variants(GlobalSingleton.currentStage)

func _stage_variants(currentStage):
	match currentStage:
		3:
			allowSwap = true
		_:
			pass

func _physics_process(_delta):
	limit_bottom = $"../../MapHandler/Mapa/Deathzone".global_position.y
	
	if allowSwap:
		#global_position.y = min($"../../Jogador".global_position.y, $"../../Jogador2".global_position.y)
		if ($"../../Jogador".global_position.y < $"../../Jogador2".global_position.y and hasSwapped):
			reparent($"../../Jogador")
			position = Vector2(0,0)
			position.y += -264
			hasSwapped = !hasSwapped
		elif ($"../../Jogador2".global_position.y < $"../../Jogador".global_position.y and !hasSwapped):
			reparent($"../../Jogador2")
			position = Vector2(0,0)
			position.y += -264
			hasSwapped = !hasSwapped
