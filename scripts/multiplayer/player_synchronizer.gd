# player.gd
extends KinematicBody

var player_id: int
var position: Vector3

# Function to update player position on the server
func sync_player_position():
	var msg = { "type": "move", "player_id": player_id, "position": position }
	send_message(msg)

# Handle player movement (on client-side)
func update_position(delta: float):
	var input_vector = Vector3.ZERO
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.z -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.z += 1

	var velocity = input_vector.normalized() * 10  # Adjust speed here
	position += velocity * delta
	move_and_slide(velocity)

	sync_player_position()  # Send updated position to server
