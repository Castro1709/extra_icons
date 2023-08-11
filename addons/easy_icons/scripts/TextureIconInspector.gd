@tool
extends EditorInspectorPlugin

func _can_handle(obj: Object) -> bool:
	return obj is IconTexture

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if name == "import_size":
		if object is IconTexture:
			var online := Button.new()
			online.text = "Online load"
			add_custom_control(online)
			online.pressed.connect(object.set_to_icon_name_async)
			var local := Button.new()
			local.text = "Local load"
			add_custom_control(local)
			local.pressed.connect(object.set_texture_local)
			var download := Button.new()
			download.text = "Import to local"
			add_custom_control(download)
			download.pressed.connect(object.download_icon)
	return false
