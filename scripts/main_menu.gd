extends Control
var stageSelected: int = 1

func _ready():
	$MenuBGM.play()
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	#$MenuBGM.stop()
	$MenuBGM.stream_paused = true
	match stageSelected:
		1:
			get_tree().change_scene_to_file(str("res://scenes/stages/stage",stageSelected,".tscn"))
		_:
			$MenuBGM.stream_paused = false
			#$Message.visible = true

func _on_level_pressed() -> void:
	if stageSelected == 8:
		stageSelected = 1
	else:
		stageSelected += 1
	
	match stageSelected:
		1: $Message.text = "DEFAULT"
		_: $Message.text = "???"
		
	$StageSelected.text = str(stageSelected)

func _on_exit_pressed() -> void:
	get_tree().quit()
