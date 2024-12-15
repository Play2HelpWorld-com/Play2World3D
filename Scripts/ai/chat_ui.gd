extends Control

# Replace with your Gemini AI API details
var api_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyDGICS7oJGqYttTeHHp7RaYlBKeJHlREGI"

# References to UI nodes
@onready var user_input = $LineEdit
@onready var response_label = $RichTextLabel
@onready var send_button = $Button

func _ready():
	# Connect the button to the send_prompt function using Callable
	send_button.connect("pressed", Callable(self, "_on_send_button_pressed"))

# Send the user's input to the Gemini AI API
func _on_send_button_pressed():
	var user_prompt = user_input.text.strip_edges()
	if user_prompt != "":
		response_label.text = "Loading..."
		send_request({"prompt": user_prompt})
		user_input.text = ""  # Clear input field

# Make the HTTP request to Gemini AI
func send_request(payload: Dictionary):
	var http_request = HTTPRequest.new()
	add_child(http_request)  # Add to the scene tree temporarily
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))

	# Create the correct payload structure for the Gemini AI API
	var request_body = {
		"prompt": {
			"text": payload["prompt"]
		},
		"model_parameters": {
			"temperature": 0.7,  # Adjust for creativity (lower = more deterministic, higher = more creative)
			"maxOutputTokens": 256  # Adjust the token limit for the response
			}
		}

	# Make the HTTP request
	http_request.request(
		api_url,
		["Content-Type: application/json"],  # Headers
		HTTPClient.METHOD_POST,
		JSON.stringify(request_body)  # Convert payload to JSON string
	)


# Handle the response from Gemini AI
func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	var body_text = body.get_string_from_utf8()  # Convert the response body to a string
	if response_code == 200:
		var json = JSON.new()  # Create a JSON parser instance
		var response = json.parse(body_text)
		if response.error == OK:
			var predictions = response.result["predictions"]
			var ai_response = predictions[0].get("content", "No response received.")
			response_label.text = ai_response
		else:
			response_label.text = "Error parsing response: " + str(response.error)
	else:
		response_label.text = "Failed to connect to Gemini AI. Response code: " + str(response_code)
