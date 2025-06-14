extends Control
var stageSelected: int = 0

func _ready():
	stageSelected = GlobalSingleton.currentStage
	GlobalSingleton._reset_score()
	GlobalSingleton.victory = false
	get_tree().debug_collisions_hint = false
	$StageSelected.text = str(stageSelected)
	_set_level_name()
	$MenuBGM.play()
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	#$MenuBGM.stop()
	$MenuBGM.stream_paused = true
	get_tree().change_scene_to_file(str("res://scenes/stages/stage",stageSelected,".tscn"))
	GlobalSingleton.currentStage = stageSelected

func _on_level_pressed() -> void:
	if stageSelected == 8:
		stageSelected = 0
	else:
		stageSelected += 1
	
	_set_level_name()
	
		
	$StageSelected.text = str(stageSelected)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _set_level_name():
	match stageSelected:
		0: $Message.text = "DEBUG" #HBOX - RARI
		1: $Message.text = "CABO HTML" #DEFAULT - BRUNA 
		2: $Message.text = "DE SOUZA" #THROW - FARIA 
		3: $Message.text = "CASAL DINDIN" #COOP - LETICIA/MATEUS
		4: $Message.text = "COOKIEZUDO" #DJUMP -LUCA 
		5: $Message.text = "BROCA" #AUTO - LUCAS  
		6: $Message.text = "LULULULULULULULULULULULULULULULULULULULULULULULU" #HAIL - LUZIA 
		7: $Message.text = "NITEROIA" #FLIP - RAFA 
		8: $Message.text = "OPEN YOURSELF" #SPEED - TAINÁ 
		_: $Message.text = "???" #Failsafe
