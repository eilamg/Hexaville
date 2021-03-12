extends Node2D
# class_name HexGrid2D


enum Directions {N, NE, SE, S, SW, NW}
const NEIGHBOR_OFFSETS = [
    Vector2(0, -2), Vector2(1, -1), Vector2(1, 1),
    Vector2(0, 2), Vector2(-1, 1), Vector2(-1, -1)
]

const HEX_RADIUS = 32
const HEX_COORDS_TO_POSITION = HEX_RADIUS * Vector2(1.5, 0.866025)  # sin(60)

var hexes = [] setget set_hexes


func add_hex(coordinates : Vector2):
    hexes.append(coordinates)
    update()


func remove_hex(coordinates : Vector2):
    hexes.erase(coordinates)
    update()


func set_hexes(value):
    hexes = value
    update()


func hex_coords_to_position(coordinates : Vector2):
    return coordinates * HEX_COORDS_TO_POSITION


func get_neighbor_coordinates(coordinates : Vector2, direction : int):
    return coordinates + NEIGHBOR_OFFSETS[direction]


func _draw_hex(coordinates : Vector2):
    var hex_position = hex_coords_to_position(coordinates)
    var p0 = Vector2(0, HEX_RADIUS).rotated(deg2rad(-30))
    var p1 = Vector2(0, HEX_RADIUS).rotated(deg2rad(30))
    draw_circle(hex_position, HEX_RADIUS / 8.0, Color.red)
    for i in range(6):
        draw_line(hex_position + p0, hex_position + p1, Color.red)
        p0 = p0.rotated(deg2rad(60))
        p1 = p1.rotated(deg2rad(60))


func _draw_grid():
    for hex in hexes:
        _draw_hex(hex)


func _draw():
    _draw_grid()


func generate_grid(x_min, x_max, y_min, y_max):
    var grid = []
    for y in range(y_min, y_max+1):
        for x in range(x_min, x_max+1):
            var y_offset = abs(x % 2)
            grid.append(Vector2(x, y*2 + y_offset))
    return grid


func _ready():
    hexes = generate_grid(-4, 4, -4, 4)
