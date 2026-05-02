extends Control

const MAIN_MENU_SCENE := preload("res://scenes/main_menu_screen.tscn")
const GAME_SCENE := preload("res://scenes/game_screen.tscn")
const RESULTS_SCENE := preload("res://scenes/results_screen.tscn")

var _current_screen: Control


func _ready() -> void:
	get_viewport().gui_embed_subwindows = false
	_ensure_input_actions()
	_show_main_menu()


func _show_main_menu() -> void:
	_clear_screen()
	var menu := MAIN_MENU_SCENE.instantiate() as Control
	menu.connect("play_pressed", _show_game)
	_mount_screen(menu)
	menu.call("refresh")


func _show_game() -> void:
	_clear_screen()
	var game := GAME_SCENE.instantiate() as Control
	game.connect("game_finished", _show_results)
	game.connect("main_menu_requested", _show_main_menu)
	_mount_screen(game)
	game.call("start")


func _show_results(score: int, best_score: int, is_new_best: bool) -> void:
	_clear_screen()
	var results := RESULTS_SCENE.instantiate() as Control
	results.connect("play_again_pressed", _show_game)
	results.connect("main_menu_pressed", _show_main_menu)
	_mount_screen(results)
	results.call("set_results", score, best_score, is_new_best)


func _mount_screen(screen: Control) -> void:
	_current_screen = screen
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(screen)


func _clear_screen() -> void:
	if _current_screen != null:
		_current_screen.queue_free()
		_current_screen = null


func _ensure_input_actions() -> void:
	_add_key_action("move_up", [KEY_UP, KEY_W])
	_add_key_action("move_down", [KEY_DOWN, KEY_S])
	_add_key_action("move_left", [KEY_LEFT, KEY_A])
	_add_key_action("move_right", [KEY_RIGHT, KEY_D])
	_add_key_action("pause", [KEY_ESCAPE, KEY_SPACE])


func _add_key_action(action_name: StringName, keycodes: Array) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	for keycode: int in keycodes:
		var exists := false
		for event: InputEvent in InputMap.action_get_events(action_name):
			if event is InputEventKey and (event as InputEventKey).physical_keycode == keycode:
				exists = true
				break
		if exists:
			continue

		var input_event := InputEventKey.new()
		input_event.physical_keycode = keycode as Key
		InputMap.action_add_event(action_name, input_event)
