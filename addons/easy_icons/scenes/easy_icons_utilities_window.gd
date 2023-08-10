extends Window


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%TabContainer.set_tab_icon(0,IconTexture.new("BsQuestionCircleFill"))
	%TabContainer.set_tab_icon(1,IconTexture.new("AiFillSetting"))
	%TabContainer.set_tab_icon(2,IconTexture.new("BsFillInfoCircleFill"))

func _on_react_pressed() -> void:
	OS.shell_open("https://react-icons.github.io/react-icons")

func _on_github_pressed() -> void:
	OS.shell_open("")
