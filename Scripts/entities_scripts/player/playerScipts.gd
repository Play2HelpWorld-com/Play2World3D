extends CharacterBody3D

@onready var player_body = $CharacterArmature
@onready var anim = $AnimationPlayer
@onready var camera = $"../cam_gimbal"
var angular_speed = 10
@export var speed := 40.0
@export var gravity := 4.0

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
	move_and_slide()
