extends Camera2D

func _physics_process(_delta):
	limit_bottom = get_parent().get_parent().get_node("MapHandler/Mapa/Deathzone").global_position.y
