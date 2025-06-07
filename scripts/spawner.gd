extends Node2D

@onready var inimigo = preload("res://scenes/topi.tscn")
@onready var bird = preload("res://scenes/nitpicker.tscn")
var rng = RandomNumberGenerator.new()
var cameraStartPos: int
var unloaded: bool = false

func _ready() -> void:
	cameraStartPos = $"../../Jogador".global_position.y
	$Timer.wait_time = rng.randi_range(6,12)
	$Timer.start()
	$BirdTimer.wait_time = rng.randi_range(15,20)
	$BirdTimer.start()

func _physics_process(_delta):
	if get_name().contains("1"):
		global_position.y = get_parent().get_parent().get_node("Jogador").global_position.y-392
	elif get_name().contains("2"):
		global_position.y = get_parent().get_parent().get_node("Jogador").global_position.y
	elif get_name().contains("3"):
		global_position.y = get_parent().get_parent().get_node("Jogador").global_position.y+196
	#elif get_name().contains("Bird"):
		#global_position = $"../../Jogador/Camera2D".global_position
		
	#$"../Path2D/PathFollow2D".v_offset = (cameraStartPos - $"../../Jogador".global_position.y) * -1

	if global_position.y <= -2000:
		_unload()

func _unload():
	if unloaded == false:
		if get_name().contains("Bird"):
			$"../Path2D".queue_free()
		$Timer.stop()
		$BirdTimer.stop()
		queue_free()
		unloaded = true

func _on_timer_timeout() -> void:
	if unloaded == false:
		if get_name().contains("Topi"):
			var ene = inimigo.instantiate()
			ene.position = position
			$"../Inimigos".add_child(ene)
			rng.randomize()
			$Timer.wait_time = rng.randi_range(6,12)

func _on_bird_timer_timeout() -> void:
	if unloaded == false:
		if get_name().contains("Bird"):
			$"../../AudioHandler/BirdSpawnSFX".play()
			var path_follow = PathFollow2D.new()
			path_follow.rotates = false
			var ene = bird.instantiate()
			path_follow.add_child(ene)
			path_follow.v_offset = (cameraStartPos - $"../../Jogador".global_position.y) * -1
			ene.position = position 
			$"../Path2D".add_child(path_follow)
			$BirdTimer.wait_time = rng.randi_range(15,20)
