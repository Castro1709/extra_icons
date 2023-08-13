@tool
extends EditorPlugin
var inspector_plugin = preload("res://addons/easy_icons/scripts/TextureIconInspector.gd").new()

func _enter_tree() -> void:
	add_custom_type("IconTexture","ImageTexture",preload("res://addons/easy_icons/scripts/IconTexture.gd"),preload("res://addons/easy_icons/icon.svg"))
	add_autoload_singleton("IconsHTTPService","res://addons/easy_icons/scripts/IconHTTPService.gd")
	add_inspector_plugin(inspector_plugin)
	await get_tree().process_frame
	if get_node_or_null("/root/IconsHTTPService")!=null:
		get_node("/root/IconsHTTPService").plugin_ref = self
		
	

func _exit_tree() -> void:
	remove_custom_type("IconTexture")
	remove_autoload_singleton("IconsHTTPService")
	remove_inspector_plugin(inspector_plugin)
	remove_tool_menu_item("Easy icons utilities")

func force_import() -> void:
	if get_node_or_null("/root/IconsHTTPService")!=null:
		get_editor_interface().get_resource_filesystem().scan()

var utilities = preload("res://addons/easy_icons/scenes/easy_icons_utilities_window.tscn")
func show_utilities() -> void:
	var window = utilities.instantiate()
	get_editor_interface().get_base_control().add_child(window)
	window.call_deferred("popup_centered")
