extends Button
class_name NeonButton

@export var neon_color: Color = Color(0.0, 0.82, 1.0, 1.0)
@export var fill_color: Color = Color(0.02, 0.08, 0.13, 0.95)
@export var hover_color: Color = Color(0.0, 0.23, 0.34, 0.98)
@export var pressed_color: Color = Color(0.0, 0.42, 0.55, 1.0)
@export var font_size: int = 30
@export var default_minimum_size: Vector2 = Vector2(360, 76)


func _ready() -> void:
	custom_minimum_size = default_minimum_size
	focus_mode = Control.FOCUS_NONE
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_refresh_styles()


func _refresh_styles() -> void:
	add_theme_font_size_override("font_size", font_size)
	add_theme_color_override("font_color", Color(0.85, 0.98, 1.0))
	add_theme_color_override("font_hover_color", Color.WHITE)
	add_theme_color_override("font_pressed_color", Color.WHITE)

	add_theme_stylebox_override("normal", _make_style(fill_color, neon_color, 3))
	add_theme_stylebox_override("hover", _make_style(hover_color, neon_color.lightened(0.2), 4))
	add_theme_stylebox_override("pressed", _make_style(pressed_color, neon_color.lightened(0.35), 4))
	add_theme_stylebox_override("disabled", _make_style(Color(0.03, 0.05, 0.07, 0.7), Color(0.1, 0.25, 0.3), 2))


func _make_style(fill: Color, border: Color, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(border_width)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.shadow_color = Color(border.r, border.g, border.b, 0.38)
	style.shadow_size = 16
	style.shadow_offset = Vector2.ZERO
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style
