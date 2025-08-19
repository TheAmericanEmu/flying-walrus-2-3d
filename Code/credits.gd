extends Control

# Load credits.json once and parse
var credits_dict: Dictionary = JSON.parse_string(FileAccess.open("res://credits.json", FileAccess.READ).get_as_text())

# Exported references to template panels
@export var headers: Panel
@export var sub_header: Panel
@export var title_card: Panel
@export var start_below: Button
@export var kill_point:Label

# Optional panels (not used in fixed code unless you want them)
@export var crew: Panel
@export var assest: Panel

# Control variables
var ready_move := false
var all_movers: Array[Panel] = []
var next_y := 0

# Create a centered header
func new_header(title: String) -> Panel:
	var new_header := headers.duplicate()
	new_header.name = "Header_" + title
	new_header.get_child(0).text = title

	add_child(new_header)
	await get_tree().process_frame  # Wait for layout calculations

	new_header.position.y = next_y
	next_y += new_header.size.y + 200  # Spacing between elements

	# Center horizontally
	var screen_width = get_viewport_rect().size.x
	new_header.position.x = (screen_width - new_header.size.x) / 2

	all_movers.append(new_header)
	return new_header

# Create a centered subheader (used for both subcategories and items)
func new_sub_header(title: String) -> Panel:
	var new_header := sub_header.duplicate()
	new_header.name = "SubHeader_" + title
	var label: Label = new_header.get_child(0)
	label.text = title
	label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	label.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	add_child(new_header)
	await get_tree().process_frame  # Ensure sizes are valid

	# Resize panel around the label with some padding
	var min_size := label.get_minimum_size()
	new_header.custom_minimum_size = Vector2(min_size.x + 40, min_size.y + 20)

	new_header.position.y = next_y
	next_y += new_header.size.y + 150

	# Center horizontally
	var screen_width = get_viewport_rect().size.x
	new_header.position.x = (screen_width - new_header.size.x) / 2

	all_movers.append(new_header)
	return new_header

func create_assets_label(dict:Dictionary):
	var new_header := assest.duplicate()

	var label: Label = new_header.get_child(0)
	label.text = dict["name"]
	label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	new_header.get_child(1).text = dict["creator"]
	new_header.get_child(2).text = dict["license"]
	new_header.get_child(3).text = dict["url"]
	
	add_child(new_header)
	await get_tree().process_frame  # Ensure sizes are valid

	# Resize panel around the label with some padding
	var min_size := label.get_minimum_size()
	new_header.custom_minimum_size = Vector2(min_size.x + 40, min_size.y + 20)

	new_header.position.y = next_y
	next_y += new_header.size.y + 150

	# Center horizontally
	var screen_width = get_viewport_rect().size.x
	new_header.position.x = (screen_width - new_header.size.x) / 2

	all_movers.append(new_header)
	return new_header

func _input(event: InputEvent) -> void:
	if(event.is_action("Shoot")):
		get_tree().change_scene_to_file("res://Data/Scences/MainMenu.tscn")
	

func _ready() -> void:
	start_below.button_down.connect(func ():
		print("shoot")
		get_tree().change_scene_to_file("res://Data/Scences/MainMenu.tscn")
		)
	all_movers.append(title_card)
	next_y= start_below.position.y+100
	for cat in credits_dict.keys():
		new_header(cat)
		for sub_cat in credits_dict[cat].keys():
			var sub_cat_header:Panel = await new_sub_header(sub_cat)
			for item in credits_dict[cat][sub_cat]:
				if(cat=="Crew"):
					var item_panel:Panel = await new_sub_header(item)
					var label:Label= item_panel.get_child(0)
				if(cat=="Game Assets"):
					await create_assets_label(item)
	for mover in all_movers:
		mover.show()
	if(OS.has_feature("mobile")):
		start_below.show()
	ready_move=true

var have_finshed=0
func _process(delta: float) -> void:
	if ready_move==true:
		
		for mover:Panel in all_movers:
			mover.set_position(Vector2(mover.position.x,mover.position.y-(1)))
			if mover.position.y<kill_point.position.y-100 and mover.visible==true:
				have_finshed+=1
				mover.visible=false
		if have_finshed>=len(all_movers):
			get_tree().change_scene_to_file("res://Data/Scences/MainMenu.tscn")
