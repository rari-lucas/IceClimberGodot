extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hurt: bool = false
var hurtTimer: float = 0
var currentPos = global_position.x
var SPEED = 200
@onready var path_follow = $".."

func _ready():
	_stage_variants(GlobalSingleton.currentStage)
	path_follow.progress = 0

func _stage_variants(currentStage):
	match currentStage:
		8:
			SPEED = 500
		_:
			pass

func _physics_process(delta):
	path_follow.progress += SPEED * delta 
	if currentPos > global_position.x:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	currentPos = global_position.x
	
	if global_position.x >= 1000:
		queue_free()
	
	if hurt:
		global_position.y = global_position.y + 5
	#if velocity.x > 0:
		#$Sprite.flip_h = 1
		#
	#if hurt == true:
		#hurtTimer += delta
		#if hurtTimer >= 0.5:
			#$Sprite.scale.x = $Sprite.scale.x * -1
			#hurtTimer = 0

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "Martelo" or area.name == "Headbutt":
		hurt = true
		if area.get_parent().name.contains("2"):
			GlobalSingleton._add_score("bird2")
		else:
			GlobalSingleton._add_score("bird")
		$Sprite.play("death")
		$DeathSFX.play()
		$Hitbox.set_collision_layer_value(5,false)
		$Hurtbox.set_collision_mask_value(4,false)
	elif area.name == "Deathzone":
		queue_free()
