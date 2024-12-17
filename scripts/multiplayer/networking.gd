# networking.gd
extends Node

var network: NetworkedMultiplayerENet
var players = {}

# Server setup
func start_server(port: int, max_clients: int):
	network = NetworkedMultiplayerENet.new()
	network.create_server(port, max_clients)
	get_tree().network_peer = network
	print("Server started on port", port)

# Client setup
func start_client(server_ip: String, port: int):
	network = NetworkedMultiplayerENet.new()
	network.create_client(server_ip, port)
	get_tree().network_peer = network
	print("Client connected to server:", server_ip)

# Handle network messages (e.g., player movement, spawn, etc.)
func _process(delta):
	if network.get_available_packet_count() > 0:
		var packet = network.get_packet()
		handle_network_packet(packet)

func handle_network_packet(packet):
	var data = parse_json(packet.get_string_from_utf8())
	if data.has("type"):
		match data["type"]:
			"move": handle_player_move(data)
			"spawn": handle_player_spawn(data)
			"disconnect": handle_player_disconnect(data)

# Broadcast message to all connected clients
func broadcast_message(message: Dictionary):
	var msg_json = JSON.stringify(message)
	for peer in network.get_peers():
		peer.put_packet(msg_json.to_utf8())

# Send message to specific peer (client/server)
func send_message(peer_id: int, message: Dictionary):
	var msg_json = JSON.stringify(message)
	network.get_peer(peer_id).put_packet(msg_json.to_utf8())
