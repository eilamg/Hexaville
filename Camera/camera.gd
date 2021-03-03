extends Camera


export var SPEED = 10.0
export var SPRINT = 2.0


func _ready():
    map_keys()


func map_keys():
    var action_list = InputMap.get_actions()

    var key_mappings = {
        "move_left": KEY_A,
        "move_right": KEY_D,
        "move_up": KEY_W,
        "move_down": KEY_S,
        "sprint": KEY_SHIFT
    }

    for action in key_mappings:
        if not(action in action_list):
            var event = InputEventKey.new()
            event.scancode = key_mappings[action]
            InputMap.add_action(action)
            InputMap.action_add_event(action, event)


func _process(delta):
    handle_input(delta)


func handle_input(delta):
    var velocity = Vector3.ZERO

    var sprinting = Input.is_action_pressed("sprint")

    if Input.is_action_pressed("move_left"):
        velocity.x -= 1
    if Input.is_action_pressed("move_right"):
        velocity.x += 1
    if Input.is_action_pressed("move_up"):
        velocity.z -= 1
    if Input.is_action_pressed("move_down"):
        velocity.z += 1

    translation += velocity.rotated(Vector3(0, 1, 0).normalized(), rotation.y) * delta * SPEED * (SPRINT if sprinting else 1)


# func _input(event):
#     if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#         rotate_y(-event.relative.x * 0.01)
#         y_rotation.rotate_x(-event.relative.y * 0.01)
#         y_rotation.rotation_degrees.x = clamp(y_rotation.rotation_degrees.x, -70, 70)
