extends Control
class_name GridBoard

@export var columns: int = 24
@export var rows: int = 24
@export var background_color: Color = Color(0.01, 0.025, 0.05, 1.0)
@export var border_color: Color = Color(0.0, 0.74, 1.0, 0.9)
@export var grid_color: Color = Color(0.0, 0.45, 0.7, 0.23)


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	draw_rect(rect, background_color, true)
	draw_rect(rect, border_color, false, 4.0)

	var cell_w := size.x / float(columns)
	var cell_h := size.y / float(rows)
	for column: int in range(1, columns):
		var x := float(column) * cell_w
		draw_line(Vector2(x, 0.0), Vector2(x, size.y), grid_color, 1.0)
	for row: int in range(1, rows):
		var y := float(row) * cell_h
		draw_line(Vector2(0.0, y), Vector2(size.x, y), grid_color, 1.0)


func cell_rect(cell: Vector2i, inset: float = 2.0) -> Rect2:
	var cell_size := Vector2(size.x / float(columns), size.y / float(rows))
	var cell_position := Vector2(cell.x * cell_size.x, cell.y * cell_size.y)
	return Rect2(cell_position + Vector2(inset, inset), cell_size - Vector2(inset * 2.0, inset * 2.0))
