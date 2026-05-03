extends Control
class_name MainMenuScreen

signal play_pressed

@export var background_color: Color = Color(0.005, 0.012, 0.028, 1.0)
@export var neon_color: Color = Color(0.0, 0.82, 1.0, 1.0)

const DESIGN_SIZE := Vector2(720, 1280)

var _best_label: Label


func _ready() -> void:
	_build()
	_update_best_score()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_layout()


func refresh() -> void:
	_update_best_score()


func _build() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = background_color
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var title := Label.new()
	title.name = "Title"
	title.text = "SNAKEY"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 86)
	title.add_theme_color_override("font_color", Color(0.78, 0.97, 1.0))
	add_child(title)

	var subtitle := Label.new()
	subtitle.name = "Subtitle"
	subtitle.text = "NEON SNAKE"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 24)
	subtitle.add_theme_color_override("font_color", Color(0.3, 0.82, 1.0, 0.86))
	add_child(subtitle)

	_best_label = Label.new()
	_best_label.name = "BestScore"
	_best_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_best_label.add_theme_font_size_override("font_size", 30)
	_best_label.add_theme_color_override("font_color", Color(0.75, 0.95, 1.0, 0.95))
	add_child(_best_label)

	var play_button := NeonButton.new()
	play_button.name = "PlayButton"
	play_button.text = "PLAY"
	play_button.pressed.connect(func() -> void: play_pressed.emit())
	add_child(play_button)

	var hint := Label.new()
	hint.name = "Hint"
	hint.text = "Swipe to turn"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 24)
	hint.add_theme_color_override("font_color", Color(0.54, 0.8, 0.9, 0.82))
	add_child(hint)

	_layout()


func _layout() -> void:
	if not has_node("Title"):
		return

	var viewport_size := size
	if viewport_size == Vector2.ZERO:
		viewport_size = DESIGN_SIZE

	var layout_scale := minf(viewport_size.x / DESIGN_SIZE.x, viewport_size.y / DESIGN_SIZE.y)
	var side_margin := maxf(32.0 * layout_scale, viewport_size.x * 0.067)
	var button_width := minf(360.0 * layout_scale, viewport_size.x - side_margin * 2.0)
	var button_height := 76.0 * layout_scale

	var title := get_node("Title") as Label
	var subtitle := get_node("Subtitle") as Label
	var play_button := get_node("PlayButton") as NeonButton
	var hint := get_node("Hint") as Label

	title.position = Vector2(side_margin, viewport_size.y * 0.24)
	title.size = Vector2(viewport_size.x - side_margin * 2.0, 120.0 * layout_scale)
	subtitle.position = Vector2(side_margin, title.position.y + 104.0 * layout_scale)
	subtitle.size = Vector2(viewport_size.x - side_margin * 2.0, 40.0 * layout_scale)
	_best_label.position = Vector2(side_margin, viewport_size.y * 0.48)
	_best_label.size = Vector2(viewport_size.x - side_margin * 2.0, 48.0 * layout_scale)
	play_button.position = Vector2((viewport_size.x - button_width) * 0.5, viewport_size.y * 0.61)
	play_button.size = Vector2(button_width, button_height)
	hint.position = Vector2(side_margin, viewport_size.y * 0.78)
	hint.size = Vector2(viewport_size.x - side_margin * 2.0, 48.0 * layout_scale)


func _update_best_score() -> void:
	if _best_label != null:
		_best_label.text = "BEST  %d" % _get_best_score()


func _get_best_score() -> int:
	var manager := get_node_or_null("/root/SaveManager")
	if manager == null:
		return 0
	return int(manager.get("best_score"))
