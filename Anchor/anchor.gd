extends Spatial
class_name Anchor


signal clicked(anchor)
signal moused_over(anchor)


func _on_input_event(camera, event, click_position, click_normal, shape_idx):
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == 1:
            emit_signal("clicked", self)


func _on_mouse_entered():
    emit_signal("moused_over", self)
