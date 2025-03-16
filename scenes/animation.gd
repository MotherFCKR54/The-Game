extends AnimatedSprite2D
@onready var csillag = $"."
@onready var felirat = $"."

func _ready() -> void:
	csillag.play()
	felirat.play()
	
