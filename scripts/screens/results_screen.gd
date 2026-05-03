extends Control
class_name ResultsScreen

signal play_again_pressed
signal main_menu_pressed

@export var background_color: Color = Color(0.005, 0.012, 0.028, 1.0)

const DESIGN_SIZE := Vector2(720, 1280)

var _score_label: Label
var _best_label: Label
var _new_best_label: Label
var _score: int = 0
var _best: int = 0
var _new_best: bool = false


func _ready() -> void:
	_build()
	set_results(_score, _best, _new_best)


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_layout()


func set_results(score: int, best_score: int, is_new_best: bool) -> void:
	_score = score
	_best = best_score
	_new_best = is_new_best
	if _score_label == null:
		return
	_score_label.text = "%d" % _score
	_best_label.text = "BEST  %d" % _best
	_new_best_label.visible = _new_best


func _build() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = background_color
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var title := Label.new()
	title.name = "Title"
	title.text = "GAME OVER"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 58)
	title.add_theme_color_override("font_color", Color(0.78, 0.97, 1.0))
	add_child(title)

	var score_caption := Label.new()
	score_caption.name = "ScoreCaption"
	score_caption.text = "SCORE"
	score_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_caption.add_theme_font_size_override("font_size", 24)
	score_caption.add_theme_color_override("font_color", Color(0.35, 0.84, 1.0, 0.86))
	add_child(score_caption)

	_score_label = Label.new()
	_score_label.name = "Score"
	_score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_score_label.add_theme_font_size_override("font_size", 92)
	_score_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(_score_label)

	_best_label = Label.new()
	_best_label.name = "BestScore"
	_best_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_best_label.add_theme_font_size_override("font_size", 30)
	_best_label.add_theme_color_override("font_color", Color(0.75, 0.95, 1.0, 0.95))
	add_child(_best_label)

	_new_best_label = Label.new()
	_new_best_label.name = "NewBest"
	_new_best_label.text = "NEW BEST"
	_new_best_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_new_best_label.add_theme_font_size_override("font_size", 28)
	_new_best_label.add_theme_color_override("font_color", Color(0.35, 0.95, 1.0))
	add_child(_new_best_label)

	var play_again := NeonButton.new()
	play_again.name = "PlayAgainButton"
	play_again.text = "PLAY AGAIN"
	play_again.pressed.connect(func() -> void: play_again_pressed.emit())
	add_child(play_again)

	var main_menu := NeonButton.new()
	main_menu.name = "MainMenuButton"
	main_menu.text = "MAIN MENU"
	main_menu.pressed.connect(func() -> void: main_menu_pressed.emit())
	add_child(main_menu)

	_layout()


func _layout() -> void:
	if not has_node("Title"):
		return

	var viewport_size := size
	if viewport_size == Vector2.ZERO:
		viewport_size = DESIGN_SIZE

	var layout_scale := minf(viewport_size.x / DESIGN_SIZE.x, viewport_size.y / DESIGN_SIZE.y)
	var side_margin := maxf(32.0 * layout_scale, viewport_size.x * 0.056)
	var button_width := minf(360.0 * layout_scale, viewport_size.x - side_margin * 2.0)
	var button_height := 76.0 * layout_scale

	var title := get_node("Title") as Label
	var score_caption := get_node("ScoreCaption") as Label
	var play_again := get_node("PlayAgainButton") as NeonButton
	var main_menu := get_node("MainMenuButton") as NeonButton

	title.position = Vector2(side_margin, viewport_size.y * 0.18)
	title.size = Vector2(viewport_size.x - side_margin * 2.0, 82.0 * layout_scale)
	score_caption.position = Vector2(side_margin, viewport_size.y * 0.32)
	score_caption.size = Vector2(viewport_size.x - side_margin * 2.0, 40.0 * layout_scale)
	_score_label.position = Vector2(side_margin, viewport_size.y * 0.36)
	_score_label.size = Vector2(viewport_size.x - side_margin * 2.0, 120.0 * layout_scale)
	_best_label.position = Vector2(side_margin, viewport_size.y * 0.49)
	_best_label.size = Vector2(viewport_size.x - side_margin * 2.0, 48.0 * layout_scale)
	_new_best_label.position = Vector2(side_margin, viewport_size.y * 0.54)
	_new_best_label.size = Vector2(viewport_size.x - side_margin * 2.0, 44.0 * layout_scale)
	play_again.position = Vector2((viewport_size.x - button_width) * 0.5, viewport_size.y * 0.65)
	play_again.size = Vector2(button_width, button_height)
	main_menu.position = Vector2((viewport_size.x - button_width) * 0.5, viewport_size.y * 0.75)
	main_menu.size = Vector2(button_width, button_height)
