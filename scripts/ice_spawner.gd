extends Node2D

@onready var gelo = preload("res://scenes/ice_spike.tscn")
var rng = RandomNumberGenerator.new()
var unloaded: bool = false

func _ready() -> void:
	$Timer.wait_time = rng.randi_range(4,10)
	$Timer.start()

func _physics_process(_delta):
	if global_position.y <= -2100:
		_unload()

func _unload():
	if unloaded == false:
		if $"..".get_child(0).name == "Inimigos":
			$"../Inimigos".queue_free()
		$Timer.stop()
		queue_free()
		unloaded = true

func _on_timer_timeout() -> void:
	if unloaded == false:
		var ene = gelo.instantiate()
		ene.position = position
		$"../Inimigos".add_child(ene)
		rng.randomize()
		$Timer.wait_time = rng.randi_range(4,10)

func _on_jogador_spawn_bonus_veggie() -> void:
	_unload()
