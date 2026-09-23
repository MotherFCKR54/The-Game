# A menü animált képeinek lejátszását indítja el. A két változó ugyanarra a saját node-ra mutat.
extends AnimatedSprite2D
@onready var csillag = $"."
@onready var felirat = $"."

# A jelenet indulásakor mindkét hivatkozáson elindítja az animációt; ezek ugyanazt a node-ot jelentik.
func _ready() -> void:
	csillag.play()
	felirat.play()
	
