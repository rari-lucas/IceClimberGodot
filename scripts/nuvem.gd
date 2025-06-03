extends CharacterBody2D
var SPEED = 5

func _physics_process(_delta):
	position.x -= SPEED
	
	if (position.x <= -1065):
		position.x = 960
	
	if (position.x >= 1090):
		position.x = -985
