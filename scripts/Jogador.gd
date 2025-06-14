extends CharacterBody2D

var SPEED = 225.0
var JUMP_VELOCITY = -775.0
var puloAereo = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var globalTimer: float = 0
var attackTimer: float = 0
var isActionable: bool = true
var deathPos: Vector2
var confirm = false 
var maxHeight: float = 814
var direction: float = 0
var bonusStageReached: bool = false
var checkpointYPos: float = 814
var checkpointXPos: float = 0
var stageVar = ""
var nextCheckpointJump: float = 48
var isUnarmed = ""
var seelCount: int = 0
var specialCheck: bool = false
var isP2 = ""
var flip: bool = false
signal block_Hit(Vector2)
signal current_Height_Changed(maxHeight)
signal spawn_Bonus_Veggie()
signal special()
signal bonusStarted()
signal unlockCell()
@onready var seal = preload("res://scenes/seal.tscn")

func _ready() -> void:
	Engine.time_scale = 1
	stageVar = ""
	$Sprite.material.set("shader_parameter/target_color", Vector4(0.051,0.302,0.769,1))
	GlobalSingleton.playersLeft = 1
	_stage_variants(GlobalSingleton.currentStage)

func _stage_variants(currentStage):
	match currentStage:
		2:
			stageVar = "alternateAtk"
			isUnarmed = "unarmed_"
		3:
			if name.contains("2"):
				#$Sprite.use_parent_material = false
				#$Sprite.material.set("shader_parameter/target_color", Vector4(0.051,0.302,0.769,1)) #AZUL
				$Sprite.material.set("shader_parameter/target_color", Vector4(0.616,0.11,0.282,1)) #ROSA
				isP2 = "2"
			stageVar = "allowGlobalCheckpoint"
			GlobalSingleton.checkpointY = 814
			GlobalSingleton.playersLeft = 2
		4:
			stageVar = "allowDJump"
			nextCheckpointJump = 96
		5:
			stageVar = "allowAutoScroll"
		6:
			isUnarmed = "unarmed_"
			$Sprite.material.set("shader_parameter/target_color", Vector4(0.616,0.11,0.282,1))
			stageVar = "specialStage"
		8:
			stageVar = "allowRun"
			SPEED = 500
			JUMP_VELOCITY = -1500
			gravity = 4000
			Engine.time_scale = 2
		_:
			pass

func _physics_process(delta):
	#region Ações do jogador
	if isActionable:
		direction = Input.get_axis(str("esquerda", isP2), str("direita", isP2))
		
		#Movimento do personagem
		if direction:
			if Input.is_action_pressed(str('correr', isP2)) and stageVar == "allowRun":
				velocity.x = direction * (SPEED + 700)
			else:
				velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		#Ação de pulo
		if Input.is_action_just_pressed(str("pulo", isP2)):
			_pulo()
		
		#if velocity.y >= 0 and $AudioHandler/JumpSFX.playing:
				#$AudioHandler/JumpSFX.stop()
		
		#Tempo no ar pós pulo.
		#Varia de acordo com tempo que botão está pressionado.
		if Input.is_action_pressed(str("pulo", isP2)):
			globalTimer += delta
			if globalTimer >= 0.5 or velocity.y > 0:
				velocity.y += gravity * delta
			else:
				velocity.y = velocity.y
		else:
			velocity.y += gravity * delta
		
		if Input.is_action_just_released(str("pulo", isP2)):
			globalTimer = 0
		
		#Ação de ataque
		if Input.is_action_just_pressed(str("ataque", isP2)) and is_on_floor():
			if isUnarmed != "unarmed_":
				isActionable = false
				await _ataque()
			else:
				if stageVar == "alternateAtk" and seelCount < 5:
					_spawn_seal()
	#endregion
	
	#region Física do personagem
	#teleporta jogador ao chegar no fim da tela
	if (position.x <= -1065):
		position.x = 960
	
	if (position.x >= 1090):
		position.x = -985

	#Exporta cabeçada para quebra de blocos
	if ($Headbutt.overlaps_body($"../MapHandler/Mapa")):
		block_Hit.emit($Headbutt/HeadbuttArea.global_position)
	
	#Ativa/desativa cabeçada
	if velocity.y < 0 and isActionable:
		#$Headbutt.set_collision_layer_value(7,true)
		#$Headbutt.set_collision_mask_value(2,true)
		$Headbutt/HeadbuttArea.disabled = false
		$Headbutt.monitoring = true
		$Headbutt.set_deferred("monitorable",true)
	else:
		#$Headbutt.set_collision_layer_value(7,false)
		#$Headbutt.set_collision_mask_value(2,false)
		$Headbutt/HeadbuttArea.disabled = true
		$Headbutt.monitoring = false
		$Headbutt.set_deferred("monitorable",false)
	
	#Exporta para mapa para controlar a câmera.
	if stageVar != "allowGlobalCheckpoint":
		if stageVar == "allowAutoScroll":
			if Engine.time_scale == 1:
				maxHeight = maxHeight-2
				current_Height_Changed.emit(maxHeight)
		else: 
			if maxHeight >= checkpointYPos + 98:
				maxHeight = checkpointYPos
				current_Height_Changed.emit(maxHeight)
	else:
		if maxHeight >= GlobalSingleton.checkpointY + 98:
			if name.contains("2"):
				maxHeight = GlobalSingleton.checkpointY
				current_Height_Changed.emit(maxHeight)
			else:
				maxHeight = GlobalSingleton.checkpointY
				current_Height_Changed.emit(maxHeight)
	
	if isActionable:
		velocity.y += gravity * delta
		
		if is_on_floor():
			unlockCell.emit()
			puloAereo = 1
			$Timers/AirTimer.stop()
		
		move_and_slide()
	#endregion
	
	#region Animações do personagem
	if isActionable:
	#Animação idle quando não há input ou após aterrissar.
		if is_on_floor():
			if (!Input.is_anything_pressed()) or (!Input.is_action_pressed(str("ataque", isP2)) and direction == 0):
				$Sprite.play(str(isUnarmed,"idle"))
		
		#animação de queda sempre que personagem está no ar
		if velocity.y > 0 and !is_on_floor():
			$Sprite.play(str(isUnarmed,"fall"))
		
		#animação de corrida que inverte o lado de acordo com input
		if direction:
			$Sprite.flip_h = direction < 0
			if is_on_floor():
				$Sprite.play(str(isUnarmed,"run"))
	
	if stageVar == "alternateAtk":
		$Camera2D/SubViewport/SeelCounter.text = str(5 - seelCount)
	
	if !specialCheck and stageVar == "specialStage": ##Timer para mensagem especial
		if $"../AudioHandler/CreditsBGM".playing:
			if $"../AudioHandler/CreditsBGM".get_playback_position() >= 12:
				special.emit()
				specialCheck = true
	
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
	#if !$Timers/iFrames.is_stopped() and $Timers/iFrameAnimTimer.is_stopped():
		#$Sprite.material.set("shader_parameter/target_color", Vector4(1,1,1,1))
		#$Timers/iFrameAnimTimer.start()
	#endregion
	
	#region Conclusão de fase
	if ($Hurtbox.overlaps_area(get_parent().get_node("MapHandler/Mapa/BonusZone")) == true
	and is_on_floor() and !bonusStageReached and isActionable):
		get_parent().get_node("AudioHandler/StageBGM").stop()
		_bonus_Stage_Start()
	#endregion

func _pulo():
	if is_on_floor():
		velocity.y += JUMP_VELOCITY
		$Sprite.play(str(isUnarmed,"jump"))
		$AudioHandler/JumpSFX.play()
	if stageVar == "allowDJump":
		if (Input.is_action_just_pressed(str("pulo", isP2)) 
			and !is_on_floor() and puloAereo > 0):
			$Sprite.play(str(isUnarmed,"jump"))
			$AudioHandler/JumpSFX.play()
			velocity.y = JUMP_VELOCITY-300
			puloAereo += -1

func _ataque():
	$Sprite.play("attack")
	$Sprite.offset.x = 4
	$Martelo/MarteloArea.position = $Hurtbox.position + Vector2(50,-40)
	if $Sprite.flip_h:
		$Sprite.offset.x = -2
		$Martelo/MarteloArea.position = $Hurtbox.position + Vector2(-25, -40)
	$Martelo/MarteloArea.disabled = 0
	$Martelo/MarteloArea/AttackCooldown.start()

func _spawn_seal(): 
	if stageVar == "alternateAtk":
		$Sprite.play("spawnSeal")
		var ene = seal.instantiate()
		$"../EnemyHandler/Inimigos".add_child(ene)
		ene.global_position = global_position
		seelCount += 1

func _bonus_Stage_Start() -> void:
	isActionable = false
	current_Height_Changed.emit(maxHeight)
	if stageVar == "allowGlobalCheckpoint":
		bonusStarted.emit()
	$Timers/BonusTimer.start()

func _load_result_screen():
	get_tree().change_scene_to_file("res://scenes/result_screen.tscn")

func _on_respawn_timeout() -> void:
	var rng = randi_range(0,1)
	$Sprite.play(str(isUnarmed,"idle"))
	$Sprite.offset.y = 0
	$Sprite.rotation = 0
	isActionable = true
	if rng == 1:
		position.x = 850
	else:
		position.x = -850
	if stageVar != "allowGlobalCheckpoint":
		global_position.y = checkpointYPos
	else:
		global_position.y = GlobalSingleton.checkpointY
	#$Headbutt/HeadbuttArea.disabled = false
	$Headbutt.monitoring = true
	$Headbutt.set_deferred("monitorable",true)
	set_collision_layer_value(1,true)
	$Headbutt/HeadbuttArea.disabled = false
	confirm = false
	$Timers/iFrames.start()
	$Timers/iFrameAnimTimer.start()
	$Timers/AirTimer.start()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox" or area.name == "Deathzone":
		if stageVar == "allowAutoScroll":
			#get_tree().change_scene_to_file("res://scenes/result_screen.tscn")
			call_deferred("_load_result_screen")
		else:
			if bonusStageReached == false:
				isActionable = false
				$Sprite.material.set("shader_parameter/target_color", Vector4(1,1,1,1))
				$Sprite.material.set("shader_parameter/target_color2", Vector4(1,1,1,1))
				$AudioHandler/DeathSFXTimer.start()
				set_collision_layer_value(1,false)
				$Hurtbox.set_collision_mask_value(5,false)
				$Hurtbox.set_collision_mask_value(8,false)
				#$Headbutt/HeadbuttArea.disabled = true
				$Headbutt.monitoring = false
				$Headbutt.set_deferred("monitorable",false)
				deathPos = position
				$Timers/Respawn.start()
			else:
				GlobalSingleton.playersLeft += -1
				if GlobalSingleton.playersLeft == 0:
					GlobalSingleton.victory = false
					#get_tree().change_scene_to_file("res://scenes/result_screen.tscn")
					call_deferred("_load_result_screen")
			
	if area.name == "Checkpoint":
		if stageVar != "allowGlobalCheckpoint":
			checkpointYPos = area.get_child(0).global_position.y
			area.position.y = area.position.y - nextCheckpointJump
		else:
			GlobalSingleton.checkpointY = area.get_child(0).global_position.y
			checkpointYPos = area.get_child(0).global_position.y
			area.position.y = area.position.y - nextCheckpointJump
		
	if area.name == "PopoArea" and is_on_floor():
		isActionable = false
		$"../AudioHandler/BonusStageBGM".stop()
		$Sprite.play("win")
		$"../Popo".play("win")
		$"../AudioHandler/CreditsBGM".play()
		

func _on_attack_cooldown_timeout() -> void:
	$Sprite.offset.x = 0
	$Martelo/MarteloArea.disabled = 1
	if($Timers/Respawn.is_stopped()):
		if (Input.is_action_pressed(str("ataque", isP2)) and is_on_floor()):
			_ataque()
		else:
			isActionable = true

func _on_i_frames_timeout() -> void:
	$Sprite.material.set("shader_parameter/target_color2", Vector4(0.89,0.525,0.345,1))
	if (isP2 == "2" || stageVar == "specialStage"):
		$Sprite.material.set("shader_parameter/target_color", Vector4(0.616,0.11,0.282,1))
	else:
		$Sprite.material.set("shader_parameter/target_color", Vector4(0.051,0.302,0.769,1))
	$Hurtbox.set_collision_mask_value(5,true)
	$Hurtbox.set_collision_mask_value(8,true)

func _on_i_frame_anim_timer_timeout() -> void:
	if flip:
		$Sprite.material.set("shader_parameter/target_color2", Vector4(0.89,0.525,0.345,1))
		if (isP2 == "2" || stageVar == "specialStage"):
			$Sprite.material.set("shader_parameter/target_color", Vector4(0.616,0.11,0.282,1))
		else:
			$Sprite.material.set("shader_parameter/target_color", Vector4(0.051,0.302,0.769,1))
	else:
		$Sprite.material.set("shader_parameter/target_color", Vector4(1,1,1,1))
		$Sprite.material.set("shader_parameter/target_color2", Vector4(1,1,1,1))
	flip = !flip
	if !$Timers/iFrames.is_stopped():
		$Timers/iFrameAnimTimer.start()

func _on_death_sfx_timer_timeout() -> void:
	$AudioHandler/DeathSFX.play()

func _on_bonus_timer_timeout() -> void:
	if maxHeight > -2500:
		maxHeight += -10
		current_Height_Changed.emit(maxHeight)
		_bonus_Stage_Start()
	if maxHeight <= -2500:
		maxHeight = -2500
		isActionable = true
		bonusStageReached = true
		isUnarmed = "unarmed_"
		spawn_Bonus_Veggie.emit()
		get_parent().get_node("AudioHandler/BonusStageBGM").play()

func _on_headbutt_body_entered(body: Node2D) -> void:
	if body.name == "Condor":
		GlobalSingleton.victory = true
		Engine.time_scale = 0
		get_parent().get_node("AudioHandler/BonusStageBGM").stop()
		get_parent().get_node("AudioHandler/VictoryBGM").play()

func _on_victory_bgm_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/result_screen.tscn")

func _on_air_timer_timeout() -> void:
	position.x = 0
	position.y = maxHeight-150

func _on_jogador_bonus_started() -> void:
	bonusStageReached = true
	isUnarmed = "unarmed_"
