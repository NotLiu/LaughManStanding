extends HTTPRequest

var http_request : HTTPRequest
# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the HTTPRequest node
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	# Set your GPT Laugh Man's URL
	var url = "http://your-gpt-laugh-man-url/joke"

	var body = JSON.new().stringify({"name": "Godette"})
	var error = http_request.request(url, [], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func _on_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
