@tool
extends EditorInspectorPlugin

func _can_handle(obj: Object) -> bool:
	return obj is IconTexture

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if name == "icon_name":
		if object is IconTexture:
			var button := Button.new()
			button.text = "Try load"
			add_custom_control(button)
			button.pressed.connect(object.set_to_icon_name_async)
	return false
