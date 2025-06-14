extends Control

var textCounter: int = 0

func _on_jogador_special() -> void:
	$Text.visible = true
	$SpecialTimer.start()


func _on_special_timer_timeout() -> void:
	textCounter += 1
	if textCounter <=7:
		match textCounter:
			1:
				$Text.text = "MAS EU PRECISAVA PEDIR DO MEU JEITINHO PRA PODER VALER"
			2:
				$Text.text = "E ESPERO QUE ESSE JEITINHO TE FACA TAO FELIZ QUANTO VOCE ME FAZ A CADA DIA"
			3:
				$Text.text = "ME SINTO MUITO SORTUDO POR TER ALGUEM TAO COMPANHEIRA COMO VOCE PARA DIVIDIR A VIDA"
			4:
				$Text.text = "EU SOU MUITO GRATO POR TODOS OS MOMENTOS INCRIVEIS QUE VOCE ME PROPORCIONOU NESSES 2 ANOS E MEIO(+2)"
			5:
				$Text.text = "E QUERO AGRADECER AINDA MAIS VIVENDO MUITOS MAIS MOMENTOS ASSIM COM VOCE"
			6:
				$Text.text = "MAS SO SE VOCE TAMBEM QUISER. POR ISSO, EU PRECISO PERGUNTAR..."
			7:
				$Text.text = "LUZIA, QUER CASAR COMIGO?"
