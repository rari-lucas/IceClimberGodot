extends Control
var stageSelected: int = 1

func _ready():
	$MenuBGM.play()
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	#$MenuBGM.stop()
	$MenuBGM.stream_paused = true
	get_tree().change_scene_to_file(str("res://scenes/stages/stage",stageSelected,".tscn"))
	GlobalSingleton.currentStage = stageSelected

func _on_level_pressed() -> void:
	if stageSelected == 8:
		stageSelected = 1
	else:
		stageSelected += 1
	
	match stageSelected:
		1: $Message.text = "DEFAULT"
		2: $Message.text = "SPEED"
		3: $Message.text = "DJUMP"
		4: $Message.text = "RADIO"
		5: $Message.text = "AUTO"
		6: $Message.text = "COOP"
		7: $Message.text = "HAIL"
		8: $Message.text = "MEME"
		_: $Message.text = "???"
		
	$StageSelected.text = str(stageSelected)

func _on_exit_pressed() -> void:
	get_tree().quit()
