extends Control
class_name GridBoard

@export var columns: int = 24
@export var rows: int = 24
@export var background_color: Color = Color(0.01, 0.025, 0.05, 1.0)
@export var border_color: Color = Color(0.0, 0.74, 1.0, 0.9)
@export var grid_color: Color = Color(0.0, 0.82, 1.0, 0.88)
@export var grid_line_width: float = 2.0
@export var border_line_width: float = 3.0


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	draw_rect(rect, background_color, true)
	_draw_grid()


func _draw_grid() -> void:
	if columns <= 0 or rows <= 0:
		return

	for column: int in range(columns + 1):
		var x := _grid_boundary(column, columns, size.x)
		var vertical_color := border_color if column == 0 or column == columns else grid_color
		var vertical_width := border_line_width if column == 0 or column == columns else grid_line_width
		_draw_vertical_boundary(x, vertical_width, vertical_color)

	for row: int in range(rows + 1):
		var y := _grid_boundary(row, rows, size.y)
		var horizontal_color := border_color if row == 0 or row == rows else grid_color
		var horizontal_width := border_line_width if row == 0 or row == rows else grid_line_width
		_draw_horizontal_boundary(y, horizontal_width, horizontal_color)


func cell_rect(cell: Vector2i, inset: float = 2.0) -> Rect2:
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


func _draw_vertical_boundary(x: float, width: float, color: Color) -> void:
	var left := clampf(roundf(x - width * 0.5), 0.0, maxf(0.0, size.x - width))
	draw_rect(Rect2(Vector2(left, 0.0), Vector2(width, size.y)), color, true)


func _draw_horizontal_boundary(y: float, width: float, color: Color) -> void:
	var top := clampf(roundf(y - width * 0.5), 0.0, maxf(0.0, size.y - width))
	draw_rect(Rect2(Vector2(0.0, top), Vector2(size.x, width)), color, true)
