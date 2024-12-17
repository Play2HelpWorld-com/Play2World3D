# client.gd
extends Node

var player_id: int

# Handle player spawn (from server)
func handle_player_spawn(data: Dictionary):
	if data.has("player_id"):
		var new_player = Player.new()  # Create a new player node
		new_player.player_id = data["player_id"]
		new_player.position = data["position"]
		players[data["player_id"]] = new_player
		add_child(new_player)

# Handle player movement (from server)
func handle_player_move(data: Dictionary):
	var player = players.get(data["player_id"])
	if player:
		player.position = data["position"]

# Handle player disconnections (from server)
func handle_player_disconnect(data: Dictionary):
	var player_id = data["player_id"]
	var player = players.get(player_id)
	if player:
		player.queue_free()  # Remove disconnected player from client
		players.erase(player_id)
