# server.gd
extends Node

var player_count = 0
var players = {}  # Dictionary to store all active players

# Handle a new player joining the server
func handle_player_join(data: Dictionary):
	var player_id = player_count
	player_count += 1

	var new_player = Player.new()  # Create a new player node
	new_player.player_id = player_id
	players[player_id] = new_player
	add_child(new_player)

	# Send player data to other clients
	var spawn_msg = { "type": "spawn", "player_id": player_id, "position": new_player.position }
	broadcast_message(spawn_msg)

	# Send the new player their player ID
	var msg = { "type": "your_id", "player_id": player_id }
	send_message(data["peer_id"], msg)

# Handle a player disconnecting from the server
func handle_player_disconnect(data: Dictionary):
	var player_id = data["player_id"]
	var player = players.get(player_id)
	if player:
		player.queue_free()  # Remove player from the game
		players.erase(player_id)
	
	# Notify all clients that the player has disconnected
	var msg = { "type": "disconnect", "player_id": player_id }
	broadcast_message(msg)

# Broadcast message to all connected clients
func broadcast_message(message: Dictionary):
	var msg_json = JSON.stringify(message)
	for peer in network.get_peers():
		peer.put_packet(msg_json.to_utf8())

# Send message to specific peer
func send_message(peer_id: int, message: Dictionary):
	var msg_json = JSON.stringify(message)
	network.get_peer(peer_id).put_packet(msg_json.to_utf8())
