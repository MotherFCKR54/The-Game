# A karakter vízszintes mozgása, gravitációja és mozgás közbeni animációja.
extends CharacterBody2D


# Vízszintes haladási sebesség pixel/másodpercben.
const SPEED = 100.0
# Előkészített ugrási sebesség; ezt a konstansot a jelenlegi mozgáskód még nem használja.
const JUMP_VELOCITY = -400.0

# A node-hivatkozást akkor keresi meg, amikor a karakter gyermekei már elérhetők.
@onready var animated_sprite = $AgentAnimator/AnimatedSprite2D


# Minden fizikai lépésben frissíti a gravitációt, a mozgást és az animációt; a delta az eltelt idő másodpercben.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Balra -1, jobbra +1, bemenet nélkül 0 az irány.
	var direction := Input.get_axis("Move_left", "Move_right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.play("default")
		# Balra haladáskor vízszintesen tükrözi a karakter képét.
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.stop()
		animated_sprite.play("idle")
	# A velocity alapján mozgatja a karaktert és kezeli az ütközéseket.
	move_and_slide()
