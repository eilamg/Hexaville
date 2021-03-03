extends Spatial
tool


signal anchor_clicked(glob_pos)


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


#func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
#    if event is InputEventMouseButton:
#        prints(camera, event, click_position, click_normal, shape_idx)


func _on_anchor_clicked(anchor):
    emit_signal("anchor_clicked", anchor.global_transform.origin - Vector3(0, 0.1, 0))
    print(anchor.global_transform.origin)
