extends TileMapLayer
var celula_atual: Vector2i
var celulaDeathzone: Vector2i
signal celulaDestruida(celulaAtingida)
signal blocoGrande(bool)
@onready var blockAnimation = preload("res://scenes/broken_block.tscn")

func _ready() -> void:
	$Deathzone.global_position.y = 1005

func _physics_process(_delta):
	celula_atual = local_to_map(to_local(get_parent().get_parent().get_node("Jogador/Headbutt/HeadbuttArea").global_position))
	if get_cell_tile_data(celula_atual):
		if (get_cell_source_id(celula_atual) == 2 
		and get_cell_atlas_coords(celula_atual).y in[0,1,2]):
			_block_hit(celula_atual)

func _block_hit(celula_atingida) -> void:
	var blockAni = blockAnimation.instantiate()
	if (get_cell_source_id(celula_atual) == 2 
	and get_cell_atlas_coords(celula_atual).y == 0):
		blocoGrande.emit(false)
	else:
		blocoGrande.emit(true)
	celulaDestruida.emit(to_global(map_to_local(celula_atingida)))
	get_parent().get_node("brokenBlockInst").add_child(blockAni)
	erase_cell(celula_atual)
	get_parent().get_parent().get_node("AudioHandler/BlockBreakSFX").play()
	get_parent().get_parent().get_node("Jogador").velocity.y = 0


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
