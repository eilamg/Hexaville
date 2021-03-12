extends Spatial
class_name Tile
tool


onready var mesh = $mesh

export(MeshLibrary) var mesh_library setget set_mesh_library
export(int) var selected_mesh setget select_mesh
export(int, 0, 5) var orientation setget set_orientation


func _ready():
    select_mesh(selected_mesh)
    set_orientation(orientation)


func set_mesh_library(value):
    mesh_library = value


func select_mesh(value):
    selected_mesh = value
    if mesh != null:
        mesh.mesh = mesh_library.get_item_mesh(selected_mesh)


func set_orientation(value):
    orientation = value
    if mesh != null:
        mesh.rotation_degrees = Vector3(0, 90 - 60 * orientation, 0)
