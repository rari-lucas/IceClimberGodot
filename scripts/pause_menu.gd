extends Control

@onready var stageBGM = get_parent().get_parent().get_parent().get_parent().get_node("AudioHandler/StageBGM")
@onready var bonusBGM = get_parent().get_parent().get_parent().get_parent().get_node("AudioHandler/BonusStageBGM")
@onready var cenaMain = get_parent().get_parent().get_parent().get_parent()
var paused = false

func _ready():
	hide()

func _process(_delta):
	if Input.is_action_just_pressed("pausar"):
		pauseMenu()

func pauseMenu():
	if !paused:
		$PauseSFX.play()
		show()
		$VBoxContainer/Resume.grab_focus()
		Engine.time_scale = 0
		if stageBGM.playing:
			stageBGM.stream_paused = true
		
		if bonusBGM.playing:
			bonusBGM.stream_paused = true
	paused = !paused

func _on_resume_pressed() -> void:
	
	$PauseSFX.play()
	hide()
	Engine.time_scale = 1
	if stageBGM.stream_paused == true:
		stageBGM.stream_paused = false
	
	if bonusBGM.stream_paused == true:
		bonusBGM.stream_paused = false


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
