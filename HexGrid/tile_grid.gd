extends Spatial
class_name TileGrid


onready var TileScene = preload("res://Tile/tile.tscn")
onready var AnchorScene = preload("res://Anchor/anchor.tscn")

var ghost_tile

signal grid_updated

enum Directions {N, NE, SE, S, SW, NW}
const NEIGHBOR_OFFSETS = [
    Vector2(0, -2), Vector2(1, -1), Vector2(1, 1),
    Vector2(0, 2), Vector2(-1, 1), Vector2(-1, -1)
]

export var hex_radius = 0.5 / sin(deg2rad(60)) setget set_hex_radius

var tiles = {}  # setget set_tiles


func _ready():
    ghost_tile = GhostTile.new(load("res://Tile/tiles.meshlib"), self)
    add_child(ghost_tile)


func set_hex_radius(value):
    hex_radius = value
    emit_signal("grid_updated")


func set_tile(hex_coordinates : Vector2, tile):
    assert(get_tile(hex_coordinates) == null)  # break if trying to overwrite an existing tile
    tiles[hex_coordinates] = tile
    add_child(tile)
    tile.global_transform.origin = hex_coords_to_position(hex_coordinates)
    tile.name = ("tile" if tile is Tile else "anchor") + "_" + str(hex_coordinates)
    emit_signal("grid_updated")
    if tile is Tile:  # could also be Anchor
        add_anchors_around_tile(hex_coordinates)
    elif tile is Anchor:
        tile.connect("clicked", self, "_on_anchor_clicked")
        tile.connect("moused_over", ghost_tile, "_on_anchor_moused_over")


func _on_anchor_clicked(anchor):
    var coordinates = get_tile_coordinates(anchor)

    var tile = TileScene.instance()
    tile.select_mesh(ghost_tile.selected_mesh)
    tile.set_orientation(ghost_tile.orientation)

    ghost_tile.select_random_tile()

    remove_tile(coordinates)
    set_tile(coordinates, tile)
    # print(anchor, anchor_coordinates)


func add_anchors_around_tile(hex_coordinates : Vector2):
    for direction in Directions.values():
        if get_neighbor(hex_coordinates, direction) == null:
            set_tile(hex_coordinates + NEIGHBOR_OFFSETS[direction], AnchorScene.instance())


func get_tile(hex_coordinates : Vector2):
    return tiles.get(hex_coordinates)


func get_tile_coordinates(tile):
    for coordinates in tiles:
        if tiles[coordinates] == tile:
            return coordinates


func remove_tile(hex_coordinates : Vector2):
    var tile = get_tile(hex_coordinates)
    tiles.erase(hex_coordinates)
    tile.queue_free()
    emit_signal("grid_updated")


# func set_tiles(value : Dictionary):
#     tiles = value
#     emit_signal("grid_updated")


func hex_coords_to_position(hex_coordinates : Vector2):
    var v2 = hex_coordinates * hex_radius * Vector2(1.5, sin(deg2rad(60)))
    return Vector3(v2.x, 0, v2.y)


# func position_to_hex_coords(position : Vector3):
    # var v2 = Vector2(position.x, position.z) / HEX_COORDS_TO_POSITION
    # TODO: pain in the butt due to double-coords
    # Only implemenet if I actually end up needing
    # NOTE: should ignores y value


func get_neighbor(hex_coordinates : Vector2, direction : int):
    return tiles.get(hex_coordinates + NEIGHBOR_OFFSETS[direction])


#func get_all_neighbors(hex_coordinates : Vector2):
#    var neighbors = []
#    for direction in NEIGHBOR_OFFSETS:
#        neighbors.append(hex_coordinates + direction)
#    return neighbors


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
