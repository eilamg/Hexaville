extends ImmediateGeometry
class_name HexGridVisualizer


export(NodePath) var hex_grid_node
var hex_grid : HexGrid setget set_hex_grid

# var hex_grid
var points = []


func _ready():
    set_hex_grid(get_node(hex_grid_node))
    material_override = SpatialMaterial.new()
    material_override.vertex_color_use_as_albedo = true


func set_hex_grid(value : HexGrid):
    hex_grid = value
    hex_grid.connect("hex_grid_updated", self, "_on_grid_updated")
    _on_grid_updated()


func _on_grid_updated():
    points = []
    for hex in hex_grid.hexes:
        add_hexagon(hex)


func add_hexagon(hex_coords : Vector2):
    var pos = hex_grid.hex_coords_to_position(hex_coords)

    # Draw center cross
    var l = hex_grid.hex_radius / 8.0
    _add_line(pos + Vector3(l, 0, l), pos - Vector3(l, 0, l))
    _add_line(pos + Vector3(-l, 0, l), pos - Vector3(-l, 0, l))

    # Draw hex
    for i in range(6):
        var a0 = deg2rad(60 * i)
        var a1 = deg2rad(60 * (i + 1))
        _add_line(
            pos + Vector3(hex_grid.hex_radius, 0, 0).rotated(Vector3(0, 1, 0), a0),
            pos + Vector3(hex_grid.hex_radius, 0, 0).rotated(Vector3(0, 1, 0), a1)
        )


func _add_line(p1 : Vector3, p2 : Vector3):
    points.append(p1)
    points.append(p2)


func draw():
    clear()
    begin(Mesh.PRIMITIVE_LINES)
    set_color(Color.greenyellow)
    for p in points:
        add_vertex(p)
    end()


func _process(delta):
    draw()
