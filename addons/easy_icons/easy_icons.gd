@tool
extends EditorPlugin
var inspector_plugin = preload("res://addons/easy_icons/scripts/TextureIconInspector.gd").new()

func _enter_tree() -> void:
	add_custom_type("IconTexture","ImageTexture",preload("res://addons/easy_icons/scripts/IconTexture.gd"),null)
	add_autoload_singleton("IconsHTTPService","res://addons/easy_icons/scripts/IconHTTPService.gd")
	add_inspector_plugin(inspector_plugin)

func _exit_tree() -> void:
	remove_custom_type("IconTexture")
	remove_autoload_singleton("IconsHTTPService")
	remove_inspector_plugin(inspector_plugin)
