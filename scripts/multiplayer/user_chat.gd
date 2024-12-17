extends Node

# Assuming you have a method for sending the message (e.g., WebSocket, HTTP)
# Define the send_message function or replace it with the appropriate method.

func send_chat_message(message):
	# Create the message dictionary
	var msg = { "type": "chat", "content": message }

	# Serialize the dictionary to JSON string
	var json_message = JSON.stringify(msg)

	# Send the JSON message (replace with your send method)
	send_message(json_message)

# Define the send_message function (this is just a placeholder)
# Replace this with actual code to send the message (e.g., using WebSocket, HTTP, etc.)
func send_message(json_message):
	print("Sending message: ", json_message)
	# Add your actual message-sending logic here (e.g., WebSocket or HTTP request)
