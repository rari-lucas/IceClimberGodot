extends Node

var victory: bool = false
var blockScore: int = 0
var topiScore: int = 0
var birdScore: int = 0
var veggieScore: int = 0
var currentStage: int = 1

func addScore(target):
	match target:
		"block":
			blockScore += 1
		"topi":
			topiScore += 1
		"bird":
			birdScore += 1
		"veggie":
			veggieScore += 1
