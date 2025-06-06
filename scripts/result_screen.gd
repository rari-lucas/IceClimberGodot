extends Control

var flip: bool = false
var topiResult = 0
var veggieResult = 0
var birdResult = 0
var blockResult = 0
var multi = 0
var finalScore = 0

func _ready():
	Engine.time_scale = 1
	if GlobalSingleton.victory:
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/Sprite.play("win")
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ResultText.text = "YOU WIN!"
	else:
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/Sprite.play("lose")
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ResultText.text = "NO BONUS!"

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	

func _on_sprite_frame_changed() -> void:
	if $HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/Sprite.animation == "win":
		if flip:
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/Sprite.position.y += 30
		else:
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/Sprite.position.y += -30
			$winSFX.play()
	#else:
		#if flip:
			#$loseSFX.play()
	flip = !flip

func _on_sprite_animation_looped() -> void:
	#if GlobalSingleton.victory:
		#$winSFX.play()
	#else:
		#$loseSFX.play()
	pass

func _on_score_count_timeout() -> void:
	if $ScorePause.is_stopped():
		if GlobalSingleton.topiScore > topiResult:
			topiResult +=1
			multi = int($HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer2/TopiScore.text.trim_suffix(" X"))
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer3/TopiQte.text = str(topiResult)
			finalScore += multi 
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore)
			$loseSFX.play()
			if GlobalSingleton.topiScore == topiResult:
				$ScorePause.start()
			else:
				$ScoreCount.start(0.03)
		elif GlobalSingleton.veggieScore > veggieResult:
			veggieResult +=1
			multi = int($HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer2/VeggieScore.text.trim_suffix(" X"))
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer3/VeggieQte.text = str(veggieResult)
			finalScore += multi 
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore)
			$loseSFX.play()
			if GlobalSingleton.veggieScore == veggieResult:
				$ScorePause.start()
			else:
				$ScoreCount.start(0.03)
		elif GlobalSingleton.birdScore > birdResult:
			birdResult +=1
			multi = int($HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer2/BirdScore.text.trim_suffix(" X"))
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer3/BirdQte.text = str(birdResult)
			finalScore += multi 
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore)
			$loseSFX.play()
			if GlobalSingleton.birdScore == birdResult:
				$ScorePause.start()
			else:
				$ScoreCount.start(0.03)
		elif GlobalSingleton.blockScore > blockResult:
			blockResult +=1
			multi = int($HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer2/BlockScore.text.trim_suffix(" X"))
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer3/BlockQte.text = str(blockResult)
			finalScore += multi 
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore)
			$loseSFX.play()
			if GlobalSingleton.blockScore == blockResult:
				$ScorePause.start()
			else:
				$ScoreCount.start(0.03)
		else:
			pass


func _on_score_pause_timeout() -> void:
	$ScoreCount.start(0.03)
