extends CharacterBody3D

class_name Player3D

const SPEED = 10.0
const JUMP_VELOCITY = 15.0
const MOUSE_SENSITIVITY = 0.005  # Mouse sensitivity for rotation

var gravity = 9.8  # Gravity value

@onready var player_name_label: Label3D = $PlayerName
@onready var player_body = $CharacterArmature
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var camera: Node3D = $"../cam_gimbal"

var movement = Vector3.ZERO  # Movement vector
var camera_rotation_x = 0.0  # Vertical rotation clamp

func move(delta):
	# Get input vector for movement
	movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(movement.x, 0, movement.y).rotated(Vector3.UP, camera.rotation.y).normalized()

	# Apply movement in the horizontal plane
	if direction.length() > 0:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		player_body.rotation.y = lerp_angle(player_body.rotation.y, atan2(direction.x, direction.z), delta * 10.0)
		anim.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)
		anim.play("Idle")

	# Handle jump with ui_space action
	if Input.is_action_just_pressed("ui_space") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Apply jump velocity only if on the floor

	# Apply gravity if not on the ground
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0  # Reset vertical velocity when on the ground

	# Use the move_and_slide method with only the velocity argument
	move_and_slide()  # No need for the 'up' direction argument anymore

func _ready():
	player_name_label.text = name
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE  # Keep mouse visible

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Handle horizontal and vertical rotation
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera_rotation_x = clamp(camera_rotation_x - event.relative.y * MOUSE_SENSITIVITY, -90, 90)
		camera.rotation_degrees.x = camera_rotation_x

func _physics_process(delta):
	# Handle movement
	move(delta)
