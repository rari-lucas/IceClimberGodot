extends Node

var victory: bool = false
var blockScore: int = 0
var topiScore: int = 0
var birdScore: int = 0
var veggieScore: int = 0
var blockScore2: int = 0
var topiScore2: int = 0
var birdScore2: int = 0
var veggieScore2: int = 0
var currentStage: int = 0
var checkpointY: float = 814
var playersLeft: int = 1

func _add_score(target):
	match target:
		"block":
			blockScore += 1
		"topi":
			topiScore += 1
		"bird":
			birdScore += 1
		"veggie":
			veggieScore += 1
		"block2":
			blockScore2 += 1
		"topi2":
			topiScore2 += 1
		"bird2":
			birdScore2 += 1
		"veggie2":
			veggieScore2 += 1

func _reset_score():
	blockScore = 0
	topiScore = 0
	birdScore = 0
	veggieScore = 0
	blockScore2 = 0
	topiScore2 = 0
	birdScore2 = 0
	veggieScore2 = 0
