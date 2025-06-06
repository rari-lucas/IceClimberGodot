extends TileMapLayer
var celula_atual: Vector2i
var celulaEsquerda: Vector2i
var celulaDeathzone: Vector2i
var vegetables: Array
var currentVeggie: Vector2 = Vector2(randi_range(0,4),randi_range(0,1))
signal celulaDestruida(celulaAtingida)
signal blocoGrande(bool)
@onready var blockAnimation = preload("res://scenes/broken_block.tscn")
@onready var loadedPlayer = get_parent().get_parent().get_node("Jogador")

func _ready() -> void:
	$Deathzone.global_position.y = 1005
	vegetables = get_used_cells_by_id(1)
	var i = 0
	while (i < vegetables.size()):
		erase_cell(vegetables[i])
		i += 1

func _physics_process(_delta):
	celula_atual = local_to_map(to_local(loadedPlayer.get_node("Headbutt/HeadbuttArea").global_position))
	if get_cell_tile_data(celula_atual):
		if (get_cell_source_id(celula_atual) == 2 
		and get_cell_atlas_coords(celula_atual).y in[0,1,2]):
			_block_hit(celula_atual)
	
	var celula_veggie = local_to_map(to_local(loadedPlayer.global_position))
	if get_cell_tile_data(celula_veggie):
		if (get_cell_source_id(celula_veggie) == 1):
			_get_veggie(celula_veggie)
	#celulaEsquerda = local_to_map(to_local(loadedPlayer.get_node("Headbutt2/HeadbuttArea").global_position))
	#if get_cell_tile_data(celulaEsquerda):
		#if (get_cell_source_id(celulaEsquerda) == 2 
		#and get_cell_atlas_coords(celulaEsquerda).y in[0,1,2]):
			#_block_hit(celulaEsquerda)

func _block_hit(celula_atingida) -> void:
	GlobalSingleton.addScore("block")
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

func _get_veggie(celula_atingida):
	GlobalSingleton.addScore("veggie")
	$"../../AudioHandler/VeggieSFX".play()
	erase_cell(celula_atingida)

func _on_jogador_current_height_changed(maxHeight: Variant) -> void:
	$Deathzone.global_position.y = maxHeight+335
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


func _on_jogador_block_hit(celulaAtual: Variant) -> void:
	
	var celulaAtualMap = local_to_map(to_local(celulaAtual))
	if get_cell_tile_data(celulaAtualMap):
		if (get_cell_source_id(celulaAtualMap) == 2 
		and get_cell_atlas_coords(celulaAtualMap).y in[0,1,2]):
			_block_hit(celulaAtualMap)
