@tool
extends Node
var plugin_ref

func get_new_http() -> HTTPRequest:
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(remove_http.bind(http))
	return http

func remove_http(_d,_d2,_d3,_d4,http:HTTPRequest) -> void:
	http.queue_free()

func force_import() -> void:
	plugin_ref.force_import()
