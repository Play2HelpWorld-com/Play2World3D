extends Node

var http_request : HTTPRequest

func _ready():
	# Create and add HTTPRequest as a child to the current node
	http_request = HTTPRequest.new()
	add_child(http_request)

	# Register a user when ready
	register_user("example_user", "example_password")

func register_user(username, password):
	var url = "http://localhost:3000/register"
	var data = { "username": username, "password": password }
	var json_data = JSON.stringify(data)  # Correctly serialize the data dictionary to a JSON string
	var headers = ["Content-Type: application/json"]  # Set the appropriate content type

	# Make the HTTP request to the server with POST method and the given data
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)

# Callback function when the HTTP request completes
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 201:
		print("User registered: ", body)
	else:
		print("Error during registration: ", response_code, body)
