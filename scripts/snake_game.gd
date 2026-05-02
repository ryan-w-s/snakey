extends Control
class_name SnakeGame

signal score_changed(score: int, best_score: int)
signal game_over(score: int, best_score: int, is_new_best: bool)
signal pause_changed(paused: bool)

@export var columns: int = 24
@export var rows: int = 24
@export var initial_step_time: float = 0.18
@export var minimum_step_time: float = 0.075
@export var speedup_per_food: float = 0.006
@export var points_per_food: int = 10
@export var swipe_threshold: float = 36.0

var score: int = 0
var is_paused: bool = false

var _snake: Array[Vector2i] = []
var _food: Vector2i = Vector2i.ZERO
var _direction: Vector2i = Vector2i.RIGHT
var _pending_direction: Vector2i = Vector2i.RIGHT
var _has_started: bool = false
var _step_time: float = initial_step_time
var _step_accumulator: float = 0.0
var _rng := RandomNumberGenerator.new()
var _touch_start := Vector2.ZERO
var _is_swiping := false

@onready var _board: GridBoard = GridBoard.new()
@onready var _renderer: SnakeRenderer = SnakeRenderer.new()


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_rng.randomize()

	_board.columns = columns
	_board.rows = rows
	_board.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_board.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_board)

	_renderer.columns = columns
	_renderer.rows = rows
	_renderer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_renderer.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_renderer)

	reset()


func reset() -> void:
	score = 0
	is_paused = false
	_direction = Vector2i.RIGHT
	_pending_direction = Vector2i.RIGHT
	_has_started = false
	_step_time = initial_step_time
	_step_accumulator = 0.0

	var center := Vector2i(columns / 2.0, rows / 2.0)
	_snake.clear()
	_snake.append(center)
	_snake.append(center + Vector2i.LEFT)
	_snake.append(center + Vector2i.LEFT * 2)
	_spawn_food()
	_emit_score()
	_refresh_renderer()
	pause_changed.emit(false)


func set_paused(paused: bool) -> void:
	if is_paused == paused:
		return
	is_paused = paused
	pause_changed.emit(is_paused)


func toggle_pause() -> void:
	set_paused(not is_paused)


func _process(delta: float) -> void:
	if is_paused or not _has_started:
		return

	_step_accumulator += delta
	while _step_accumulator >= _step_time:
		_step_accumulator -= _step_time
		_step()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_up"):
		_try_turn(Vector2i.UP)
	elif event.is_action_pressed("move_down"):
		_try_turn(Vector2i.DOWN)
	elif event.is_action_pressed("move_left"):
		_try_turn(Vector2i.LEFT)
	elif event.is_action_pressed("move_right"):
		_try_turn(Vector2i.RIGHT)
	elif event.is_action_pressed("pause"):
		toggle_pause()
	elif event is InputEventKey:
		_handle_key_input(event as InputEventKey)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch_event := event as InputEventScreenTouch
		if touch_event.pressed:
			_touch_start = touch_event.position
			_is_swiping = true
		else:
			if not _is_swiping:
				return
			_is_swiping = false
			_handle_swipe(touch_event.position - _touch_start)
	elif event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed:
				_touch_start = mouse_event.position
				_is_swiping = true
			else:
				if not _is_swiping:
					return
				_is_swiping = false
				_handle_swipe(mouse_event.position - _touch_start)


func _handle_swipe(delta: Vector2) -> void:
	if delta.length() < swipe_threshold:
		return

	if absf(delta.x) > absf(delta.y):
		_try_turn(Vector2i.RIGHT if delta.x > 0.0 else Vector2i.LEFT)
	else:
		_try_turn(Vector2i.DOWN if delta.y > 0.0 else Vector2i.UP)


func _handle_key_input(event: InputEventKey) -> void:
	if not event.pressed or event.echo:
		return

	match event.physical_keycode:
		KEY_UP, KEY_W:
			_try_turn(Vector2i.UP)
		KEY_DOWN, KEY_S:
			_try_turn(Vector2i.DOWN)
		KEY_LEFT, KEY_A:
			_try_turn(Vector2i.LEFT)
		KEY_RIGHT, KEY_D:
			_try_turn(Vector2i.RIGHT)
		KEY_ESCAPE, KEY_SPACE:
			toggle_pause()


func _try_turn(new_direction: Vector2i) -> void:
	if is_paused:
		return
	if not _has_started:
		_direction = new_direction
		_pending_direction = new_direction
		_align_starting_body(new_direction)
		_has_started = true
		return
	if new_direction + _direction == Vector2i.ZERO:
		return
	_pending_direction = new_direction


func _step() -> void:
	_direction = _pending_direction
	var next_head := _snake[0] + _direction
	var will_grow := next_head == _food

	if _is_wall_collision(next_head) or _is_body_collision(next_head, will_grow):
		_finish_game()
		return

	_snake.insert(0, next_head)
	if will_grow:
		score += points_per_food
		_step_time = maxf(minimum_step_time, _step_time - speedup_per_food)
		_spawn_food()
		_emit_score()
	else:
		_snake.pop_back()

	_refresh_renderer()


func _spawn_food() -> void:
	var available_cells: Array[Vector2i] = []
	for x: int in range(columns):
		for y: int in range(rows):
			var cell := Vector2i(x, y)
			if not _snake.has(cell):
				available_cells.append(cell)

	if available_cells.is_empty():
		_finish_game()
		return

	_food = available_cells[_rng.randi_range(0, available_cells.size() - 1)]


func _is_wall_collision(cell: Vector2i) -> bool:
	return cell.x < 0 or cell.y < 0 or cell.x >= columns or cell.y >= rows


func _is_body_collision(cell: Vector2i, will_grow: bool) -> bool:
	var body_limit := _snake.size() if will_grow else _snake.size() - 1
	for index: int in range(body_limit):
		if _snake[index] == cell:
			return true
	return false


func _align_starting_body(direction: Vector2i) -> void:
	var head := _snake[0]
	_snake.clear()
	_snake.append(head)
	_snake.append(head - direction)
	_snake.append(head - direction * 2)
	_refresh_renderer()


func _finish_game() -> void:
	set_paused(true)
	var new_best := _submit_score(score)
	game_over.emit(score, _get_best_score(), new_best)


func _emit_score() -> void:
	score_changed.emit(score, _get_best_score())


func _refresh_renderer() -> void:
	_renderer.set_board_size(columns, rows)
	_renderer.set_state(_snake, _food)


func _get_best_score() -> int:
	var manager := get_node_or_null("/root/SaveManager")
	if manager == null:
		return 0
	return int(manager.get("best_score"))


func _submit_score(final_score: int) -> bool:
	var manager := get_node_or_null("/root/SaveManager")
	if manager == null:
		return false
	return bool(manager.call("submit_score", final_score))
