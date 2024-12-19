extends CharacterBody3D

class_name Player

const SPEED = 10.0
const JUMP_VELOCITY = 15.0
const MOUSE_SENSITIVITY = 0.005  # Mouse sensitivity for rotation

var gravity = 9.8  # Gravity value

@onready var player_name_label: Label3D = $PlayerName
@onready var player_body = $CharacterArmature
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var camera: Node3D = $CameraView

#var movement = Vector3.ZERO  
var angular_speed = 10
@export var speed := 40.0

var movement
var direction

func _physics_process(delta):
	move(delta)

func move(delta):
	movement = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down') 
	#direction = (transform.basis * Vector3(movement.x, 0, movement.y)).normalized()
	direction = Vector3(movement.x, 0, movement.y).rotated(Vector3.UP, camera.rotation.y).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		player_body.rotation.y = lerp_angle(player_body.rotation.y, atan2(velocity.x, velocity.z), delta * angular_speed)
		anim.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed) 
		anim.play("Idle")
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		
	move_and_slide()



func _ready():
	player_name_label.text = name
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if camera == null:
		print("Camera node not found!")

# Removed camera rotation handling
func _unhandled_input(event):
	# Mouse movement input is now ignored
	pass
