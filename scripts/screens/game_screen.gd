extends Control
class_name GameScreen

signal game_finished(score: int, best_score: int, is_new_best: bool)
signal main_menu_requested

@export var background_color: Color = Color(0.005, 0.012, 0.028, 1.0)

const DESIGN_SIZE := Vector2(720, 1280)

var _score_label: Label
var _best_label: Label
var _pause_button: NeonButton
var _game: SnakeGame
var _pause_overlay: Control


func _ready() -> void:
	_build()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_layout()


func start() -> void:
	if _game != null:
		_game.reset()


func _build() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = background_color
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var title := Label.new()
	title.name = "Title"
	title.text = "SNAKEY"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color(0.78, 0.97, 1.0))
	add_child(title)

	_score_label = Label.new()
	_score_label.name = "Score"
	_score_label.text = "SCORE  0"
	_score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_score_label.add_theme_font_size_override("font_size", 28)
	_score_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(_score_label)

	_best_label = Label.new()
	_best_label.name = "BestScore"
	_best_label.text = "BEST  0"
	_best_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_best_label.add_theme_font_size_override("font_size", 22)
	_best_label.add_theme_color_override("font_color", Color(0.62, 0.86, 0.94))
	add_child(_best_label)

	_pause_button = NeonButton.new()
	_pause_button.name = "PauseButton"
	_pause_button.text = "PAUSE"
	_pause_button.font_size = 18
	_pause_button.default_minimum_size = Vector2(132, 56)
	_pause_button.pressed.connect(_on_pause_pressed)
	add_child(_pause_button)

	_game = SnakeGame.new()
	_game.name = "SnakeGame"
	_game.score_changed.connect(_on_score_changed)
	_game.game_over.connect(_on_game_over)
	_game.pause_changed.connect(_on_pause_changed)

	_create_pause_overlay()
	add_child(_game)
	_layout()


func _create_pause_overlay() -> void:
	_pause_overlay = Control.new()
	_pause_overlay.name = "PauseOverlay"
	_pause_overlay.visible = false
	_pause_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_pause_overlay)

	var dim := ColorRect.new()
	dim.name = "Dim"
	dim.color = Color(0.0, 0.02, 0.04, 0.78)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	_pause_overlay.add_child(dim)

	var label := Label.new()
	label.name = "PausedLabel"
	label.text = "PAUSED"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_color_override("font_color", Color(0.78, 0.97, 1.0))
	_pause_overlay.add_child(label)

	var resume := NeonButton.new()
	resume.name = "ResumeButton"
	resume.text = "RESUME"
	resume.pressed.connect(func() -> void: _game.set_paused(false))
	_pause_overlay.add_child(resume)

	var menu := NeonButton.new()
	menu.name = "MenuButton"
	menu.text = "MAIN MENU"
	menu.pressed.connect(func() -> void: main_menu_requested.emit())
	_pause_overlay.add_child(menu)


func _layout() -> void:
	if _game == null or _pause_overlay == null or not has_node("Title"):
		return

	var viewport_size := size
	if viewport_size == Vector2.ZERO:
		viewport_size = DESIGN_SIZE

	var layout_scale := minf(viewport_size.x / DESIGN_SIZE.x, viewport_size.y / DESIGN_SIZE.y)
	var side_margin := maxf(24.0 * layout_scale, viewport_size.x * 0.055)
	var top_margin := 44.0 * layout_scale
	var pause_width := minf(132.0 * layout_scale, viewport_size.x * 0.28)
	var pause_height := 56.0 * layout_scale
	var max_board_size := minf(viewport_size.x - side_margin * 2.0, viewport_size.y * 0.58)
	var board_size := _snap_board_size(max_board_size)
	var board_x := (viewport_size.x - board_size) * 0.5
	var board_y := viewport_size.y * 0.22

	var title := get_node("Title") as Label
	title.position = Vector2(side_margin, top_margin)
	title.size = Vector2(viewport_size.x * 0.48, 48.0 * layout_scale)
	_pause_button.position = Vector2(viewport_size.x - side_margin - pause_width, top_margin - 2.0 * layout_scale)
	_pause_button.size = Vector2(pause_width, pause_height)
	_score_label.position = Vector2(side_margin, 112.0 * layout_scale)
	_score_label.size = Vector2(viewport_size.x - side_margin * 2.0, 40.0 * layout_scale)
	_best_label.position = Vector2(side_margin, 152.0 * layout_scale)
	_best_label.size = Vector2(viewport_size.x - side_margin * 2.0, 34.0 * layout_scale)
	_game.position = Vector2(board_x, board_y)
	_game.size = Vector2(board_size, board_size)

	_pause_overlay.position = Vector2.ZERO
	_pause_overlay.size = viewport_size
	var paused_label := _pause_overlay.get_node("PausedLabel") as Label
	var resume := _pause_overlay.get_node("ResumeButton") as NeonButton
	var menu := _pause_overlay.get_node("MenuButton") as NeonButton
	var menu_button_width := minf(360.0 * layout_scale, viewport_size.x - side_margin * 2.0)
	var menu_button_height := 76.0 * layout_scale
	paused_label.position = Vector2(40, viewport_size.y * 0.34)
	paused_label.size = Vector2(viewport_size.x - 80, 72)
	resume.position = Vector2((viewport_size.x - menu_button_width) * 0.5, viewport_size.y * 0.48)
	resume.size = Vector2(menu_button_width, menu_button_height)
	menu.position = Vector2((viewport_size.x - menu_button_width) * 0.5, viewport_size.y * 0.58)
	menu.size = Vector2(menu_button_width, menu_button_height)


func _snap_board_size(max_board_size: float) -> float:
	var cell_count := _game.columns if _game.columns >= _game.rows else _game.rows
	if cell_count <= 0:
		return max_board_size

	var snapped_size := floorf(max_board_size / float(cell_count)) * float(cell_count)
	return maxf(float(cell_count), snapped_size)


func _on_score_changed(score: int, best_score: int) -> void:
	_score_label.text = "SCORE  %d" % score
	_best_label.text = "BEST  %d" % best_score


func _on_pause_pressed() -> void:
	_game.toggle_pause()


func _on_pause_changed(paused: bool) -> void:
	if _pause_overlay == null:
		return
	_pause_overlay.visible = paused
	_pause_button.text = "RESUME" if paused else "PAUSE"


func _on_game_over(score: int, best_score: int, is_new_best: bool) -> void:
	game_finished.emit(score, best_score, is_new_best)
