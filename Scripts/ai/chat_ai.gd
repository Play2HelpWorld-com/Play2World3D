extends Control

# Replace with your Gemini AI API details
var api_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=AIzaSyDGICS7oJGqYttTeHHp7RaYlBKeJHlREGI"

# References to UI nodes
@onready var response_label = $VBoxContainer/ScrollContainer/RichTextLabel
@onready var user_input = $VBoxContainer/HBoxContainer/LineEdit
@onready var send_button = $VBoxContainer/HBoxContainer/Button
@onready var http_request = HTTPRequest.new()  # Declare it globally
@onready var toggle_button = $MenuButton  # Reference to the button that will toggle the VBoxContainer visibility
@onready var vbox_container = $VBoxContainer  # Reference to the VBoxContainer that will be shown/hidden

func _ready():
	# Add HTTPRequest to the scene tree if not already added
	add_child(http_request)
	
	# Connect the button to toggle the VBoxContainer visibility
	toggle_button.connect("pressed", Callable(self, "_on_toggle_button_pressed"))
	
	# Connect the send button to the send_prompt function
	send_button.connect("pressed", Callable(self, "_on_send_button_pressed"))

# Triggered when the toggle button is pressed
func _on_toggle_button_pressed():
	# Toggle the visibility of the VBoxContainer
	vbox_container.visible = !vbox_container.visible  # Invert visibility of VBoxContainer

# Triggered when the send button is pressed
func _on_send_button_pressed():
	var user_prompt = user_input.text.strip_edges()
	if user_prompt != "":
		response_label.text = "Loading..."
		send_request({"prompt": user_prompt})
		user_input.text = ""  # Clear input field
	else:
		response_label.text = "Please enter a valid prompt."

# Make the HTTP request to Gemini AI
func send_request(payload: Dictionary):
	# Disconnect previous signal connection if any
	http_request.disconnect("request_completed", Callable(self, "_on_request_completed"))
	
	# Connect the signal for request completion
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))

	# Prepare the payload structure for the Gemini AI API
	var request_body = {
		"contents": [
			{
				"role": "user",
				"parts": [
					{
						"text": "which gemini ai model is free for use for developer?\n"
					}
				]
			},
			{
				"role": "model",
				"parts": [
					{
						"text": "Unfortunately, there isn't a single, universally recognized 'Gemini AI model' that's completely free for developers..."
					}
				]
			},
			{
				"role": "user",
				"parts": [
					{
						"text": payload["prompt"]
					}
				]
			}
		],
		"generationConfig": {
			"temperature": 1,
			"topK": 40,
			"topP": 0.95,
			"maxOutputTokens": 8192,
			"responseMimeType": "text/plain"
		}
	}

	# Make the HTTP request
	var error = http_request.request(
		api_url,
		["Content-Type: application/json"],  # HTTP headers
		HTTPClient.METHOD_POST,
		JSON.stringify(request_body)  # Convert payload to JSON string
	)

	# Check if the request was successfully initiated
	if error != OK:
		response_label.text = "Failed to initiate request: " + str(error)

# Handle the response from Gemini AI
func _on_request_completed(_result: int, _response_code: int, _headers: Array, body: PackedByteArray):
	var body_text = body.get_string_from_utf8()  # Convert the response body to a string

	# Check the response code
	if _response_code == 200:
		var json = JSON.new()
		var error = json.parse(body_text)
		if error == OK:
			var response = json.get_data()

			# Print the full response for debugging
			print("Full Response: ", response)

			# Ensure the response has the expected structure
			if response.has("candidates") and response["candidates"].size() > 0:
				var ai_response = response["candidates"][0]["content"]["parts"][0]["text"]  # Accessing the text part
				response_label.text = ai_response  # Display only the text in RichTextLabel
			else:
				response_label.text = "Invalid response structure: 'candidates' not found or empty."
		else:
			response_label.text = "Error parsing response: " + str(error)
	else:
		response_label.text = "Failed with response code: " + str(_response_code)
