# Az AnimatedSprite2D saját képkockái és frame_progress értéke vezérlik az átúszást.
extends AnimatedSprite2D
var _blend_material: ShaderMaterial

# A jelenlegi és a következő képet keveri, az animáció szerkeszthető marad a SpriteFrames panelen.
func _ready() -> void:
	var blend_shader := Shader.new()
	blend_shader.code = """
shader_type canvas_item;
uniform sampler2D next_frame : source_color;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
void fragment() {
	float weight = smoothstep(0.0, 1.0, progress);
	COLOR = mix(texture(TEXTURE, UV), texture(next_frame, UV), weight);
}
"""
	_blend_material = ShaderMaterial.new()
	_blend_material.shader = blend_shader
	material = _blend_material
	frame_changed.connect(_sync_frame)
	animation_changed.connect(_sync_frame)
	_sync_frame()

# A ciklus végéről az első képre is fokozatosan vált, ezért ott sincs ugrás.
func _sync_frame() -> void:
	if sprite_frames == null or not sprite_frames.has_animation(animation):
		return
	var count := sprite_frames.get_frame_count(animation)
	if count == 0:
		return
	var next := (frame + 1) % count if sprite_frames.get_animation_loop(animation) else mini(frame + 1, count - 1)
	_blend_material.set_shader_parameter("next_frame", sprite_frames.get_frame_texture(animation, next))
	_blend_material.set_shader_parameter("progress", frame_progress)

# Az átmenet az AnimatedSprite2D időzítését követi, a pause menüvel együtt áll meg.
func _process(_delta: float) -> void:
	_blend_material.set_shader_parameter("progress", frame_progress)
