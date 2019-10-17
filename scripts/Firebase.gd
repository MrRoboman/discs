extends Node

const PROJECT_ID: String = 'discs-4891a'
const BASE_URL: String = 'https://%s.firebaseio.com/' % PROJECT_ID
const CIRCLES_URL:String = '%sdata/circles/' % BASE_URL
const GAMES_URL:String = '%sdata/games/' % BASE_URL

var http
signal request_completed

func _ready():
	http = HTTPRequest.new()
	add_child(http)
	http.connect('request_completed', self, '_on_HTTPRequest_request_completed')

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
#	print(response_code)
	var json = JSON.parse(body.get_string_from_utf8())
#	print(json.result)
	emit_signal("request_completed", json.result)

func load_data(path:String = 'data.json') -> void:
	var url:String = '%s%s' % [BASE_URL, path]
	print('GET %s' % url)
	http.request(url)

func save_data(path:String, data:Dictionary) -> void:
	var headers:Array = ["Content-Type: application/json"]
	var body:String = JSON.print(data)

	print('PATCH %s' % path)
	http.request(path, headers, true, HTTPClient.METHOD_PATCH, body)

func save_circle(key:String, circle_data:Dictionary) -> void:
	var path:String = '%s%s.json' % [CIRCLES_URL, key]
	save_data(path, circle_data)

func save_game(key:String, game_data:Dictionary) -> void:
	var path:String = '%s%s.json' % [GAMES_URL, key]
	save_data(path, game_data)

func delete_data(path:String) -> void:
	var headers:Array = ["Content-Type: application/json"]
	print('DELETE %s' % path)
	http.request(path, headers, true, HTTPClient.METHOD_DELETE)

func delete_game(key:String) -> void:
	var path:String = '%s%s.json' % [GAMES_URL, key]
	delete_data(path)