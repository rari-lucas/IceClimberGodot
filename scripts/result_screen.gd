extends Control

var flipP1: bool = false
var flipP2: bool = false
var topiResult = 0
var veggieResult = 0
var birdResult = 0
var blockResult = 0
var topiResult2 = 0
var veggieResult2 = 0
var birdResult2 = 0
var blockResult2 = 0
var multi = 0
var finalScore = 0
var finalScore2 = 0

func _ready():
	Engine.time_scale = 1
	
	if GlobalSingleton.currentStage == 3:
		$HBoxContainer/RightPanelOut.visible = true
	
	if GlobalSingleton.currentStage == 7:
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/SpriteP1.flip_v = true
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/SpriteP1.offset.y = 10
	else:
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/SpriteP1.flip_h = false
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/SpriteP1.offset.y = 0
	
	if GlobalSingleton.victory:
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/SpriteP1.play("win")
		$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/SpriteP2.play("win")
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ResultText.text = "YOU WIN!"
		$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/ResultText.text = "YOU WIN!"
	else:
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/SpriteP1.play("lose")
		$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/SpriteP2.play("lose")
		$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ResultText.text = "NO BONUS!"
		$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/ResultText.text = "NO BONUS!"

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_sprite_p1_frame_changed() -> void:
	if $HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/SpriteP1.animation == "win":
		if flipP1:
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/SpriteP1.position.y += 30
		else:
			$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/SpriteP1.position.y += -30
			$winSFX.play()
	flipP1 = !flipP1

func _on_sprite_p2_frame_changed() -> void:
	if $HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/SpriteP2.animation == "win":
		if flipP2:
			$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/SpriteP2.position.y += 30
		else:
			$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/SpriteP2.position.y += -30
			$winSFX.play()
	flipP2 = !flipP2

func _on_score_count_timeout() -> void:
	if $ScorePause.is_stopped():
		if GlobalSingleton.topiScore > topiResult || GlobalSingleton.topiScore2 > topiResult2:
			if GlobalSingleton.topiScore > topiResult:
				topiResult +=1
				multi = int($HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer2/TopiScore.text.trim_suffix(" X"))
				$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer3/TopiQte.text = str(topiResult)
				finalScore += multi 
				$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore)
				$loseSFX.play()
			if GlobalSingleton.topiScore2 > topiResult2:
				topiResult2 +=1
				multi = int($HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/ScoreContainer/VBoxContainer2/TopiScore.text.trim_suffix(" X"))
				$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/ScoreContainer/VBoxContainer3/TopiQte.text = str(topiResult2)
				finalScore2 += multi 
				$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore2)
			if GlobalSingleton.topiScore == topiResult and GlobalSingleton.topiScore2 == topiResult2:
				$ScorePause.start()
			else:
				$ScoreCount.start(0.03)
		elif GlobalSingleton.veggieScore > veggieResult || GlobalSingleton.veggieScore2 > veggieResult2:
			if GlobalSingleton.veggieScore > veggieResult:
				veggieResult +=1
				multi = int($HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer2/VeggieScore.text.trim_suffix(" X"))
				$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer3/VeggieQte.text = str(veggieResult)
				finalScore += multi 
				$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore)
				$loseSFX.play()
			if GlobalSingleton.veggieScore2 > veggieResult2:
				veggieResult2 +=1
				multi = int($HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/ScoreContainer/VBoxContainer2/VeggieScore.text.trim_suffix(" X"))
				$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/ScoreContainer/VBoxContainer3/VeggieQte.text = str(veggieResult2)
				finalScore2 += multi 
				$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore2)
				$loseSFX.play()
			if GlobalSingleton.veggieScore == veggieResult and GlobalSingleton.veggieScore2 == veggieResult2:
				$ScorePause.start()
			else:
				$ScoreCount.start(0.03)
		elif GlobalSingleton.birdScore > birdResult || GlobalSingleton.birdScore2 > birdResult2:
			if GlobalSingleton.birdScore > birdResult:
				birdResult +=1
				multi = int($HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer2/BirdScore.text.trim_suffix(" X"))
				$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer3/BirdQte.text = str(birdResult)
				finalScore += multi 
				$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore)
				$loseSFX.play()
			if GlobalSingleton.birdScore2 > birdResult2:
				birdResult2 +=1
				multi = int($HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/ScoreContainer/VBoxContainer2/BirdScore.text.trim_suffix(" X"))
				$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/ScoreContainer/VBoxContainer3/BirdQte.text = str(birdResult2)
				finalScore2 += multi 
				$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore2)
				$loseSFX.play()
			if GlobalSingleton.birdScore == birdResult and GlobalSingleton.birdScore2 == birdResult2:
				$ScorePause.start()
			else:
				$ScoreCount.start(0.03)
		elif GlobalSingleton.blockScore > blockResult || GlobalSingleton.blockScore2 > blockResult2:
			if GlobalSingleton.blockScore > blockResult:
				blockResult +=1
				multi = int($HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer2/BlockScore.text.trim_suffix(" X"))
				$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/ScoreContainer/VBoxContainer3/BlockQte.text = str(blockResult)
				finalScore += multi 
				$HBoxContainer/LeftPanelOut/LeftPanelMiddle/LeftPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore)
				$loseSFX.play()
			if GlobalSingleton.blockScore2 > blockResult2:
				blockResult2 +=1
				multi = int($HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/ScoreContainer/VBoxContainer2/BlockScore.text.trim_suffix(" X"))
				$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/ScoreContainer/VBoxContainer3/BlockQte.text = str(blockResult2)
				finalScore += multi 
				$HBoxContainer/RightPanelOut/RightPanelMiddle/RightPanelIn/VBoxContainer/Panel/Panel/FinalScore.text = str(finalScore)
				$loseSFX.play()
			if GlobalSingleton.blockScore == blockResult and GlobalSingleton.blockScore2 == blockResult2: #TODO
				$ScorePause.start()
			else:
				$ScoreCount.start(0.03)
		else:
			pass

func _on_score_pause_timeout() -> void:
	$ScoreCount.start(0.03)
