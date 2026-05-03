extends Control
class_name SnakeRenderer

@export var columns: int = 24
@export var rows: int = 24
@export var snake_head_color: Color = Color(0.76, 0.98, 1.0, 1.0)
@export var snake_body_color: Color = Color(0.0, 0.78, 1.0, 1.0)
@export var snake_shadow_color: Color = Color(0.0, 0.65, 1.0, 0.24)
@export var food_color: Color = Color(0.35, 0.95, 1.0, 1.0)
@export var food_core_color: Color = Color.WHITE

var snake: Array[Vector2i] = []
var food: Vector2i = Vector2i.ZERO


func set_board_size(new_columns: int, new_rows: int) -> void:
	columns = new_columns
	rows = new_rows
	queue_redraw()


func set_state(new_snake: Array[Vector2i], new_food: Vector2i) -> void:
	snake = new_snake.duplicate()
	food = new_food
	queue_redraw()


func _draw() -> void:
	_draw_food()
	_draw_snake()


func _draw_food() -> void:
	var rect := _cell_rect(food, 4.0)
	var center := rect.get_center()
	var radius := minf(rect.size.x, rect.size.y) * 0.42
	draw_circle(center, radius * 1.55, Color(food_color.r, food_color.g, food_color.b, 0.18))
	draw_circle(center, radius, food_color)
	draw_circle(center, radius * 0.38, food_core_color)


func _draw_snake() -> void:
	for index: int in range(snake.size() - 1, -1, -1):
		var cell := snake[index]
		var rect := _cell_rect(cell, 3.0)
		var color := snake_head_color if index == 0 else snake_body_color
		var radius := 8.0
		draw_rect(rect.grow(4.0), snake_shadow_color, true)
		draw_rounded_rect(rect, color, radius)


func _cell_rect(cell: Vector2i, inset: float) -> Rect2:
	if columns <= 0 or rows <= 0:
		return Rect2()

	var left := _grid_boundary(cell.x, columns, size.x)
	var top := _grid_boundary(cell.y, rows, size.y)
	var right := _grid_boundary(cell.x + 1, columns, size.x)
	var bottom := _grid_boundary(cell.y + 1, rows, size.y)
	var bounds := Rect2(Vector2(left, top), Vector2(right - left, bottom - top))
	return bounds.grow(-inset)


func _grid_boundary(index: int, count: int, length: float) -> float:
	return length * float(index) / float(count)


func draw_rounded_rect(rect: Rect2, color: Color, _radius: float) -> void:
	draw_rect(rect, color, true)
	var highlight := Rect2(rect.position + Vector2(3.0, 3.0), Vector2(rect.size.x - 6.0, maxf(3.0, rect.size.y * 0.18)))
	draw_rect(highlight, Color(1.0, 1.0, 1.0, 0.2), true)
