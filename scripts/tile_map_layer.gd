extends TileMapLayer
var celulaDeathzone: Vector2i
var vegetables: Array
var allowSafeBonus: bool = false
var currentVeggie: Vector2 = Vector2(randi_range(0,4),randi_range(0,1))
var cellLocked: bool = false
var cellLocked2: bool = false
signal celulaDestruida(celulaAtingida)
signal blocoGrande(bool)
@onready var blockAnimation = preload("res://scenes/broken_block.tscn")
@onready var loadedPlayer = $"../../Jogador"
var loadedPlayer2

func _ready() -> void:
	_stage_variants(GlobalSingleton.currentStage)
	$Deathzone.global_position.y = 1005
	vegetables = get_used_cells_by_id(1)
	var i = 0
	while (i < vegetables.size()):
		erase_cell(vegetables[i])
		i += 1

func _stage_variants(currentStage):
	match currentStage:
		0:
			get_tree().debug_collisions_hint = true
		3:
			loadedPlayer2 = $"../../Jogador2"
		6:
			pass #allowSafeBonus
		_:
			pass

func _physics_process(_delta):
	var celula_veggie = local_to_map(to_local(loadedPlayer.global_position))
	if get_cell_tile_data(celula_veggie):
		if (get_cell_source_id(celula_veggie) == 1):
			_get_veggie(celula_veggie, loadedPlayer.name)
	
	if loadedPlayer2 != null:
		var celula_veggie2 = local_to_map(to_local(loadedPlayer2.global_position))
		if get_cell_tile_data(celula_veggie2):
			if (get_cell_source_id(celula_veggie2) == 1):
				_get_veggie(celula_veggie2, loadedPlayer2.name)

func _block_hit(celula_atingida, jogadorNum) -> void:
	var blockAni = blockAnimation.instantiate()
	if (get_cell_source_id(celula_atingida) == 2 
	and get_cell_atlas_coords(celula_atingida).y == 0):
		blocoGrande.emit(false)
	else:
		blocoGrande.emit(true)
	celulaDestruida.emit(to_global(map_to_local(celula_atingida)))
	get_parent().get_node("brokenBlockInst").add_child(blockAni)
	erase_cell(celula_atingida)
	get_parent().get_parent().get_node("AudioHandler/BlockBreakSFX").play()
	if loadedPlayer.velocity.y <= 0:
		loadedPlayer.velocity.y = 0
	if jogadorNum == 2:
		GlobalSingleton._add_score("block2")
	else:
		GlobalSingleton._add_score("block")

func _get_veggie(celula_atingida, jogador):
	if jogador.contains("2"):
		GlobalSingleton._add_score("veggie2")
	else:
		GlobalSingleton._add_score("veggie")
	$"../../AudioHandler/VeggieSFX".play()
	erase_cell(celula_atingida)

func _on_jogador_current_height_changed(maxHeight: Variant) -> void:
	if !allowSafeBonus:
		$Deathzone.global_position.y = maxHeight+335
	#$Deathzone/DeathzoneArea.global_position.y = $Checkpoint/CheckpointArea.global_position.y + 2400
	var allCells: Array = get_used_cells()
	var currentCell: Vector2i = Vector2i(0,0)
	var i: int = 0
	while i < allCells.size():
		if get_cell_tile_data(allCells[i]):
			currentCell = allCells[i]
			if currentCell[1] > local_to_map(to_local(Vector2i($Deathzone.global_position.x,$Deathzone.global_position.y)))[1]:
				erase_cell(currentCell)
				i = i+1
			else:
				i = i+1

func _on_jogador_spawn_bonus_veggie() -> void:
	var i = 0
	while (i < vegetables.size()):
		set_cell(vegetables[i],1,currentVeggie)
		i += 1
	if GlobalSingleton.currentStage == 6:
		allowSafeBonus = true

func _on_jogador_block_hit(celulaAtual: Variant) -> void:
	var celula_atual = local_to_map(to_local(Vector2i(celulaAtual.x,celulaAtual.y)))
	var celula_left = local_to_map(to_local(Vector2i(celulaAtual.x - 25,celulaAtual.y)))
	var celula_right = local_to_map(to_local(Vector2i(celulaAtual.x + 25,celulaAtual.y)))
	
	if get_cell_tile_data(celula_atual):
		cellLocked = true
		if (get_cell_source_id(celula_atual) == 2 
		and get_cell_atlas_coords(celula_atual).y in[0,1,2]):
			_block_hit(celula_atual, 1)
	
	if get_cell_tile_data(celula_left) and cellLocked == false:
		cellLocked = true
		if (get_cell_source_id(celula_left) == 2 
		and get_cell_atlas_coords(celula_left).y in[0,1,2]):
			_block_hit(celula_left, 1)
	
	if get_cell_tile_data(celula_right) and cellLocked == false:
		cellLocked = true
		if (get_cell_source_id(celula_right) == 2 
		and get_cell_atlas_coords(celula_right).y in[0,1,2]):
			_block_hit(celula_right, 1)

func _on_jogador_2_block_hit(celulaAtual: Variant) -> void:
	var celula_atual = local_to_map(to_local(Vector2i(celulaAtual.x,celulaAtual.y)))
	var celula_left = local_to_map(to_local(Vector2i(celulaAtual.x - 25,celulaAtual.y)))
	var celula_right = local_to_map(to_local(Vector2i(celulaAtual.x + 25,celulaAtual.y)))
	
	if get_cell_tile_data(celula_atual):
		cellLocked2 = true
		if (get_cell_source_id(celula_atual) == 2 
		and get_cell_atlas_coords(celula_atual).y in[0,1,2]):
			_block_hit(celula_atual, 2)
	
	if get_cell_tile_data(celula_left) and cellLocked2 == false:
		cellLocked2 = true
		if (get_cell_source_id(celula_left) == 2 
		and get_cell_atlas_coords(celula_left).y in[0,1,2]):
			_block_hit(celula_left, 2)
	
	if get_cell_tile_data(celula_right) and cellLocked2 == false:
		cellLocked2 = true
		if (get_cell_source_id(celula_right) == 2 
		and get_cell_atlas_coords(celula_right).y in[0,1,2]):
			_block_hit(celula_right, 2)

func _on_jogador_unlock_cell() -> void:
	cellLocked = false

func _on_jogador_2_unlock_cell() -> void:
	cellLocked2 = false
