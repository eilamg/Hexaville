extends Spatial
class_name HexGrid


signal hex_grid_updated


enum Directions {N, NE, SE, S, SW, NW}
const NEIGHBOR_OFFSETS = [
    Vector2(0, -2), Vector2(1, -1), Vector2(1, 1),
    Vector2(0, 2), Vector2(-1, 1), Vector2(-1, -1)
]

export var hex_radius = 0.5 / sin(deg2rad(60)) setget set_hex_radius

var hexes = [] setget set_hexes


func set_hex_radius(value):
    hex_radius = value
    emit_signal("hex_grid_updated")


func add_hex(hex_coordinates : Vector2):
    hexes.append(hex_coordinates)
    emit_signal("hex_grid_updated")


func remove_hex(hex_coordinates : Vector2):
    hexes.erase(hex_coordinates)
    emit_signal("hex_grid_updated")


func set_hexes(value : Array):
    hexes = value
    emit_signal("hex_grid_updated")


func hex_coords_to_position(hex_coordinates : Vector2):
    var v2 = hex_coordinates * hex_radius * Vector2(1.5, sin(deg2rad(60)))
    return Vector3(v2.x, 0, v2.y)


# func position_to_hex_coords(position : Vector3):
    # var v2 = Vector2(position.x, position.z) / HEX_COORDS_TO_POSITION
    # TODO: pain in the butt due to double-coords
    # Only implemenet if I actually end up needing
    # NOTE: should ignores y value


func get_neighbor(hex_coordinates : Vector2, direction : int):
    return hex_coordinates + NEIGHBOR_OFFSETS[direction]


func get_all_neighbors(hex_coordinates : Vector2):
    var neighbors = []
    for direction in NEIGHBOR_OFFSETS:
        neighbors.append(hex_coordinates + direction)
    return neighbors


# func _input(event):
#     if event is InputEventMouseButton:
#         if event.pressed and event.button_index == 1:
#             var camera = get_tree().root.get_camera()
#             mouse_to_hex_coordinates(camera, event.position)


# func mouse_to_hex_coordinates(camera, mouse_position):
#     var from = camera.project_ray_origin(mouse_position)  # x,z depend on camera position and mouse position, y depends on mouse position
#     var ray_length = from.y / cos(deg2rad(45))  # TODO: make this actually dependant on camera rotation
#     var to = from + camera.project_ray_normal(mouse_position) * ray_length
#     print(position_to_hex_coords(to))
