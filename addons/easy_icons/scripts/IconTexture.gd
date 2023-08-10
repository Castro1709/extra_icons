@tool
extends ImageTexture

class_name IconTexture
const BaseUrl = "https://raw.githubusercontent.com/"
const IconsPrefixsUrls = {
	#----------Ant------------#
	"AiFill":"ant-design/ant-design-icons/master/packages/icons-svg/svg/filled/",
	"AiOutline":"ant-design/ant-design-icons/master/packages/icons-svg/svg/outlined/",
	"AiTwotone":"ant-design/ant-design-icons/master/packages/icons-svg/svg/twotone/",
	#----------Bootstrap-------------#
	"BsFill":"twbs/icons/main/icons/",
	"Bs":"twbs/icons/main/icons/",
	#----------boxicons-----------#
	"BiSolid":"atisawd/boxicons/master/svg/solid/bxs-",
	"BiLogo":"atisawd/boxicons/master/svg/logos/bxl-",
	"Bi":"atisawd/boxicons/master/svg/regular/bx-",
	#-----------Circum------------#
	"Ci":"Klarr-Agency/Circum-Icons/main/svg/",
	#----Devicons---#
	"Di":"vorillaz/devicons/master/!SVG/",
	#----feather----#
	"Fi":"feathericons/feather/master/icons/",
	#---Flat color------#
	"Fc":"icons8/flat-color-icons/master/svg/",
	#--Githug Octicos------#
	"Go":"primer/octicons/main/icons/",
	#--Grommet-Icons----#
	"Gr":"grommet/grommet-icons/master/public/img/",
	#---Hroicons----#
	"HiOutline":"tailwindlabs/heroicons/master/src/24/outline/",
	"HiMini":"tailwindlabs/heroicons/master/optimized/20/solid/",
	"Hi":"tailwindlabs/heroicons/master/src/24/solid/",
	#----Icons8 line A---#
	"Lia":"icons8/line-awesome/master/svg/",
	#-----Ionicos--------#
	"IoIos":"ionic-team/ionicons/main/src/svg/",
	"IoMd":"ionic-team/ionicons/main/src/svg/",
	"Io":"ionic-team/ionicons/main/src/svg/",
	#----Lucid----#
	"Lu":"lucide-icons/lucide/main/icons/",
	#---Godot----#,
	"Gd":"godotengine/godot/master/editor/icons/"
	}
const IconsWithSnakeCase = ["Di","Fc"]
const IconsSufix = {
		"Go":"-24.svg"
	}
const URLNotFound = "https://raw.githubusercontent.com/feathericons/feather/master/icons/alert-circle.svg"
@export
var icon_name : String = ""
## the library this icons name should come from
@export
var local := false
@export
var import_size := Vector2i(16,16)
@export
var import_color := Color.WHITE

func set_to_icon_name_async() -> void:
	set_texture_asyc(icon_name)

func set_texture_asyc(icon:String) -> void:
	var url = get_url_for_icon(icon)
	if !IconsHTTPService.is_inside_tree():
		await IconsHTTPService.ready
	var http = IconsHTTPService.get_new_http()
	http.request(url)
	var response = await http.request_completed
	if response[1] != 200:
		printerr(icon + ": Is not a valid name and was not found in the react icons library.")
		printerr("Tried: ",url)
		return
	var image := Image.new()
	if image.load_svg_from_buffer(response[3])!= OK:
		return
	image.resize(import_size.x,import_size.y,Image.INTERPOLATE_CUBIC)
	##Re-paint imaga to white / Import_Color
	for x_p in image.get_width():
		for y_p in image.get_height():
			var color : Color = image.get_pixel(x_p,y_p)
			color = Color(import_color.r,import_color.g,import_color.b,color.a)
			image.set_pixel(x_p,y_p,color)
	set_image(image)

func get_url_for_icon(icon : String) -> String:
	if icon.begins_with("Fa"):
		printerr("Font awesome icons are not supported for now")
	for prefix in IconsPrefixsUrls:
		if icon.begins_with(prefix):
			if prefix in IconsWithSnakeCase:
				icon = icon.trim_prefix(prefix).to_snake_case()
			else:
				icon = icon.trim_prefix(prefix).to_snake_case().replace("_","-")
			if prefix in IconsSufix:
				return BaseUrl + IconsPrefixsUrls[prefix] + icon + IconsSufix[prefix]
			else:
				return BaseUrl + IconsPrefixsUrls[prefix] + icon + ".svg"
	return URLNotFound

func _init(_icon_name:String="",from_online:bool=true):
	icon_name = _icon_name
	if icon_name != "":
		if from_online:
			set_to_icon_name_async()
