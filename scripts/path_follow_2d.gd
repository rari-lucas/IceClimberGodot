extends PathFollow2D

@onready var jogador = $"../../Jogador"

func _ready():
	rotates = false
	v_offset = jogador.global_position.y -200
