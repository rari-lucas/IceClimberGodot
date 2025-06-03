extends Node2D
var celulaExport
var tamanhoCelula

func _on_mapa_celula_destruida(celulaAtingida: Variant) -> void:
	celulaExport = celulaAtingida


func _on_mapa_bloco_grande(ehGrande: Variant) -> void:
	tamanhoCelula = ehGrande
