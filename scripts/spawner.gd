extends Node2D

@onready var inimigo = preload("res://scenes/topi.tscn")
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$Timer.wait_time = rng.randi_range(4,10)
	$Timer.start()

func _on_timer_timeout() -> void:
	var ene = inimigo.instantiate()
	ene.position = position
	get_parent().get_node("Inimigos").add_child(ene)
	rng.randomize()
	$Timer.wait_time = rng.randi_range(4,10)

func _physics_process(_delta):
	if get_name().contains("Top"):
		global_position.y = get_parent().get_parent().get_node("Jogador").global_position.y-392
	elif get_name().contains("Bot"):
		global_position.y = get_parent().get_parent().get_node("Jogador").global_position.y+196
	else:
		global_position.y = get_parent().get_parent().get_node("Jogador").global_position.y
	
	if position.y <= -2200:
		queue_free()
		
