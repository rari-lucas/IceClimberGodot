extends CharacterBody2D
var SPEED = 300

func _physics_process(_delta):
	velocity.x = SPEED * -1
	
	if (position.x <= -1065):
		position.x = 960
	
	if (position.x >= 1090):
		position.x = -985
	
	move_and_slide()
