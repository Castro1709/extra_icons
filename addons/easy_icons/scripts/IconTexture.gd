@tool
extends ImageTexture

## Access to the react icons library (not all are implemented, see limitations)
## use [member icon_name] and load from online or local to set the texture
## or do it via code like this
## [codeblock]
## var only_from_local = false
## $Sprite2D.texture = IconTexture.new("SomeIconName")
## $Button.icon = IconTexture.new("IconExampleName",only_from_local)
## [/codeblock]
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
	#-------Font aweso------#
	"FaReg":"FortAwesome/Font-Awesome/6.x/svgs/regular/",
	"FaSo":"FortAwesome/Font-Awesome/6.x/svgs/solid/",
	"Fa":"FortAwesome/Font-Awesome/6.x/svgs/brands/",
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
const IconsWithPascalCase = ["Gd"]
const IconsSufix = {
		"Go":"-24.svg"
	}
const URLNotFound = "https://raw.githubusercontent.com/feathericons/feather/master/icons/alert-circle.svg"
## Usually the Id that is shown in React icons
@export
var icon_name : String = ""
## the re-size scale, keep in mind that for example if an icons is in 24x24px even if you scale it
## to 128x128 the resolution will stay the same but with more pixels.
## meaning that importing in a bigger size than the original file is useless
@export
var import_size := Vector2i(16,16)
## if [true] the pixels with an alpha value will change its color to [member import_color],
## icons are usually black so importing them to white is usefull to change its modulate, and other
## like Fc o Gd (Flat Color Icons / Godot icons) have their own colors so importing them with changed color
## is undesired
@export
var change_color_on_import := true
## Changes all the pixel with alpha to this color, needs [member change_color_on_import] to work
@export
var import_color := Color.WHITE

func set_to_icon_name_async() -> void:
	if icon_name == "": return
	set_texture_asyc(icon_name)

func set_texture_asyc(icon:String) -> void:
	var url = get_url_for_icon(icon)
	if !IconsHTTPService.is_inside_tree():
		await IconsHTTPService.ready
	var http = IconsHTTPService.get_new_http()
	http.request(url,[],HTTPClient.METHOD_GET)
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
	if change_color_on_import:
		for x_p in image.get_width():
			for y_p in image.get_height():
				var color : Color = image.get_pixel(x_p,y_p)
				color = Color(import_color.r,import_color.g,import_color.b,color.a)
				image.set_pixel(x_p,y_p,color)
	set_image(image)

## given an icon name returns the url where it's located
func get_url_for_icon(icon : String) -> String:
	for prefix in IconsPrefixsUrls:
		if icon.begins_with(prefix):
			if prefix in IconsWithSnakeCase:
				icon = icon.trim_prefix(prefix).to_snake_case()
			elif prefix in IconsWithPascalCase:
				icon = icon.trim_prefix(prefix)
			else:
				icon = icon.trim_prefix(prefix).to_snake_case().replace("_","-")
			if prefix in IconsSufix:
				return BaseUrl + IconsPrefixsUrls[prefix] + icon + IconsSufix[prefix]
			else:
				return BaseUrl + IconsPrefixsUrls[prefix] + icon + ".svg"
	return URLNotFound

func _init(_icon_name:String="",only_from_local:bool=false):
	icon_name = _icon_name
	if icon_name != "":
		if not only_from_local:
			set_to_icon_name_async()

func download_icon(icon:String=icon_name) -> void:
	if icon_name == "": return
	var url = get_url_for_icon(icon)
	if !IconsHTTPService.is_inside_tree():
		await IconsHTTPService.ready
	var http = IconsHTTPService.get_new_http()
	http.request(url,[],HTTPClient.METHOD_GET)
	var response = await http.request_completed
	if response[1] != 200:
		printerr(icon + ": Is not a valid name and was not found in the react icons library.")
		printerr("Tried: ",url)
		return
	var image := Image.new()
	if image.load_svg_from_buffer(response[3])!= OK:
		return
	##Re-paint imaga to white / Import_Color
	if change_color_on_import:
		for x_p in image.get_width():
			for y_p in image.get_height():
				var color : Color = image.get_pixel(x_p,y_p)
				color = Color(1.0,1.0,1.0,color.a)
				image.set_pixel(x_p,y_p,color)
	image.resize(import_size.x,import_size.y,Image.INTERPOLATE_CUBIC)
	image.save_png("res://addons/easy_icons/imported/"+icon+".png")
	IconsHTTPService.force_import()

func set_texture_local() -> void:
	if icon_name == "": return
	var dir : String = "res://addons/easy_icons/imported/"+icon_name+".png"
	if ResourceLoader.exists(dir):
		var texture = ResourceLoader.load(dir)
		var img : Image = texture.get_image()
		set_image(img)
	else:
		printerr(icon_name,": Is not imported locally yet")
