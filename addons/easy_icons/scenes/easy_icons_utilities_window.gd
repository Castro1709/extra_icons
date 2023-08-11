@tool
extends Window

func _ready() -> void:
	%TabContainer.set_tab_icon(0,IconTexture.new("BsQuestionCircleFill"))
	%TabContainer.set_tab_icon(1,IconTexture.new("AiFillSetting"))
	%TabContainer.set_tab_icon(2,IconTexture.new("BsFillInfoCircleFill"))

func _on_react_pressed() -> void:
	OS.shell_open("https://react-icons.github.io/react-icons")

func _on_github_pressed() -> void:
	OS.shell_open("https://github.com/Castro1709/extra_icons")

func _on_close_requested() -> void:
	queue_free()

func _on_go_back_requested() -> void:
	queue_free()


func _on_focus_exited() -> void:
	queue_free()
