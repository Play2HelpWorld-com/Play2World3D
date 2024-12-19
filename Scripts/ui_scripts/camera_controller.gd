extends Node3D
@onready var player = $"../.."
var base_position = Vector3()
var base_rotation = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = player.position
	if Input.is_action_pressed('cam_rotation_left'):
		rotation.y += 1.0 * delta
	if Input.is_action_pressed('cam_rotation_right'):
		rotation.y -= 1.0 * delta
	if Input.is_action_pressed('cam_gimbal_up'):
		position.y -= 1.0 * delta
		rotation.x -= 0.3 * delta 
	if Input.is_action_pressed('cam_gimbal_down'):
		position.y += 1.0 * delta
		rotation.x += 0.3 * delta
	if Input.is_action_just_pressed('rotate_cam'):
		rotation_degrees.y += 90
		
		
