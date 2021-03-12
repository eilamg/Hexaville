extends MeshInstance
class_name GhostTile
tool


export(MeshLibrary) var mesh_library setget set_mesh_library
export(int) var selected_mesh setget select_mesh
export(int, 0, 5) var orientation setget set_orientation

var tile_grid

var tile_weights = []
var tile_weights_ids = []


func _init(mesh_library_, tile_grid_):
    tile_grid = tile_grid_
    set_mesh_library(mesh_library_)


func _ready():
    randomize()
    read_tile_weights_file()
    select_random_tile()


func set_mesh_library(value):
    mesh_library = value


func select_mesh(value):
    selected_mesh = value
    mesh = mesh_library.get_item_mesh(selected_mesh)


func set_orientation(value):
    orientation = value
    rotation_degrees = Vector3(0, 90 - 60 * orientation, 0)


func move_to_coordinates(coordinates):
    transform.origin = tile_grid.hex_coords_to_position(coordinates)


func _on_anchor_moused_over(anchor):
    move_to_coordinates(tile_grid.get_tile_coordinates(anchor))


func _input(event):
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == 4:
            set_orientation((orientation + 1) % 6)
        elif event.button_index == 5:
            set_orientation((orientation - 1) % 6)


# func _on_anchor_clicked(anchor):
#     var anchor_coordinates = tile_grid.get_tile_coordinates(anchor)
#     print(anchor, anchor_coordinates)

    # var tile = TileScene.instance()
    # tile.global_transform.origin = glob_pos
    # add_child(tile)

    # tile.select_mesh(ghost_tile.selected_mesh)
    # tile.set_orientation(ghost_tile.orientation)

    # var i = select_random_tile()
    # ghost_tile.select_mesh(i)
    # ghost_tile.set_orientation(randi() % 6)


func read_tile_weights_file():
    var file = File.new()

    var cumulative_weight = 0
    var _weights = []
    var _ids = []

    file.open("res://tile_weights.csv", File.READ)

    var line = file.get_csv_line()
    line = file.get_csv_line()  # skip header line
    while len(line) > 1:
        cumulative_weight += int(line[2])
        _weights.append(cumulative_weight)
        _ids.append(line[0])
        line = file.get_csv_line()

    file.close()

    tile_weights = _weights
    tile_weights_ids = _ids


func select_random_tile():
    var i = randi() % tile_weights[-1]
    select_mesh(tile_weights.bsearch(i))
    set_orientation(randi() % 6)

