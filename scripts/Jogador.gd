extends CharacterBody2D

var SPEED = 200.0
const JUMP_VELOCITY = -775.0
#var puloAereo = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var globalTimer: float = 0
var attackTimer: float = 0
var isActionable: bool = true
var deathPos: Vector2
var confirm = false 
var maxHeight: float = 813
var direction: float = 0
var bonusStageReached: bool = false
signal current_Height_Changed(maxHeight)

func _physics_process(delta):
	#region Ações do jogador
	if isActionable:
		direction = Input.get_axis("esquerda", "direita")
		
		#Movimento do personagem
		if direction:
			if Input.is_action_pressed('correr'):
				velocity.x = direction * (SPEED + 500)
			else:
				velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		#Ação de pulo
		if Input.is_action_just_pressed("pulo"):
			_pulo()
		
		#if velocity.y >= 0 and $AudioHandler/JumpSFX.playing:
				#$AudioHandler/JumpSFX.stop()
		
		#Tempo no ar pós pulo.
		#Varia de acordo com tempo que botão está pressionado.
		if Input.is_action_pressed("pulo"):
			globalTimer += delta
			if globalTimer >= 0.5 or velocity.y > 0:
				velocity.y += gravity * delta
			else:
				velocity.y = velocity.y
		else:
			velocity.y += gravity * delta
		
		if Input.is_action_just_released("pulo"):
			globalTimer = 0
		
		#Ação de ataque
		if Input.is_action_just_pressed("ataque") and is_on_floor():
			isActionable = false
			await _ataque()
	#endregion
	
	#region Física do personagem
	#teleporta jogador ao chegar no fim da tela
		if (position.x <= -1065):
			position.x = 960
		
		if (position.x >= 1090):
			position.x = -985
	
	#Exporta para mapa para controlar a câmera.
	if bonusStageReached == false:
		if maxHeight >= global_position.y + 196:
			maxHeight = global_position.y
			current_Height_Changed.emit(maxHeight)
	else:
		if maxHeight >= global_position.y:
			maxHeight = global_position.y
			current_Height_Changed.emit(maxHeight)
	
	if (isActionable):
		velocity.y += gravity * delta
		move_and_slide()

	#endregion
	
	#region Animações do personagem
	if isActionable:
	#Animação idle quando não há input ou após aterrissar.
		if is_on_floor():
			#puloAereo = 1
			if (!Input.is_anything_pressed()) or (!Input.is_action_pressed("ataque") and direction == 0):
				$Sprite.play("idle")
		
		#animação de queda sempre que personagem está no ar
		if velocity.y > 0 and !is_on_floor():
			$Sprite.play("fall")
		
		#animação de corrida que inverte o lado de acordo com input
		if direction:
			$Sprite.flip_h = direction < 0
			if is_on_floor():
				$Sprite.play("run")
	
	#Animação de morte após hit
	if !$Timers/Respawn.is_stopped() and $Timers/Respawn.time_left <= 3:
		$Sprite.play("death")
		$Sprite.offset.y = -4
		$Sprite.rotate(0.25)
		if confirm == true:
			position.y += 500 * delta
		else:
			position.y += -300 * delta
			if position.y <= deathPos.y - 75:
				confirm = true
	
	#Animação de iframes após respawn
	if !$Timers/iFrames.is_stopped() and $Timers/iFrameAnimTimer.is_stopped():
		$Sprite.set_modulate(Color(255,255,255,1))
		$Timers/iFrameAnimTimer.start()
	#endregion
	
	#region Conclusão de fase
	if ($Hurtbox.overlaps_area(get_parent().get_node("MapHandler/Mapa/BonusZone")) == true
	and is_on_floor() and maxHeight > -2400 and isActionable):
		get_parent().get_node("AudioHandler/StageBGM").stop()
		_bonus_Stage_Start()
	#endregion

func _pulo():
	if is_on_floor():
		velocity.y += JUMP_VELOCITY
		$Sprite.play("jump")
		$AudioHandler/JumpSFX.play()
	#if Input.is_action_just_pressed("pulo") and !is_on_floor() and puloAereo > 0:
		#velocity.y = JUMP_VELOCITY+200
		#PULOS_NO_AR -= 1

func _ataque():
	$Sprite.play("attack")
	$Sprite.offset.x = 4
	$Martelo/MarteloArea.position = $Hurtbox.position + Vector2(100,-20)
	if $Sprite.flip_h:
		$Sprite.offset.x = -2
		$Martelo/MarteloArea.position = $Hurtbox.position + Vector2(-100,-20)
	$Martelo/MarteloArea.disabled = 0
	$Martelo/MarteloArea/AttackCooldown.start()

func _bonus_Stage_Start() -> void:
	isActionable = false
	current_Height_Changed.emit(maxHeight)
	$Timers/BonusTimer.start()

func _on_respawn_timeout() -> void:
	$Sprite.play("idle")
	$Sprite.offset.y = 0
	$Sprite.rotation = 0
	isActionable = true
	position.x = 0
	position.y = maxHeight-10
	$Headbutt/HeadbuttArea.position.x = 0
	set_collision_layer_value(1,true)
	confirm = false
	$Timers/iFrames.start()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox" or area.name == "Deathzone":
		isActionable = false
		$Sprite.set_modulate(Color(255,255,255,1))
		$AudioHandler/DeathSFXTimer.start()
		set_collision_layer_value(1,false)
		$Hurtbox.set_collision_mask_value(5,false)
		$Hurtbox.set_collision_mask_value(8,false)
		$Headbutt/HeadbuttArea.position.x = 10000
		deathPos = position
		$Timers/Respawn.start()

func _on_attack_cooldown_timeout() -> void:
	$Sprite.offset.x = 0
	$Martelo/MarteloArea.disabled = 1
	if($Timers/Respawn.is_stopped()):
		if (Input.is_action_pressed("ataque") and is_on_floor()):
			_ataque()
		else:
			isActionable = true

func _on_i_frames_timeout() -> void:
	$Hurtbox.set_collision_mask_value(5,true)
	$Hurtbox.set_collision_mask_value(8,true)

func _on_i_frame_anim_timer_timeout() -> void:
	$Sprite.set_modulate(Color(1,1,1,1))

func _on_death_sfx_timer_timeout() -> void:
	$AudioHandler/DeathSFX.play()

func _on_bonus_timer_timeout() -> void:
	if maxHeight > -2650:
		maxHeight += -30
		current_Height_Changed.emit(maxHeight)
		_bonus_Stage_Start()
	if maxHeight <= -2650:
		isActionable = true
		bonusStageReached = true
		get_parent().get_node("AudioHandler/BonusStageBGM").play()
