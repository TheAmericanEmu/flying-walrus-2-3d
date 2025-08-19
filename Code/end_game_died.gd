extends Node3D

@export var name_label:Label3D
@export var summary_label:Label3D
@export var Cam:Camera3D
@export var bam_soud:AudioStreamPlayer3D
@export var taps:AudioStreamPlayer3D
@export var misson_report:Panel

var target_position = Vector3(-3.222,0.226,0) # Example target position
var tween_duration = 10.0 # Duration of the tween in seconds
var score_to_cash:float = 0.35
var tween:Tween
var score_overall = 0
var scores_already_submitted=false

@export var mobile_skip_button:Button
@export var skip_label:Label

signal update_discordRPC(agent_name:String)

var walrus_names:Array = [
	"Sir Tuskalot",
	"Blubba Fett",
	"Whalrus",
	"Big Chonk",
	"Slippy McFlop",
	"Flubbernugget",
	"Iceberg Larry",
	"Blubberstein",
	"Tusk Vader",
	"Soggy Joe",
	"Grumpus",
	"Slushlord",
	"Wobbleton",
	"Sir Flippers",
	"Chewbacca Jr.",
	"Snorty",
	"Captain Coldtusk",
	"Mooch",
	"Flopzilla",
	"Toothpick",
	"Brrrad Pitt",
	"Slumberwhisk",
	"Tubbz",
	"Fishstick",
	"McTuskface",
	"Loafy",
	"Chub Norris",
	"Sir Wobble-a-lot",
	"Marshmelt",
	"Huffington"
]

var walrus_operations = [
	"Operation Tusk Force",
	"Operation Blubberstorm",
	"Operation Cold Flipper",
	"Operation Mustache Recon",
	"Operation Ice Tusk Protocol",
	"Operation Seal the Deal",
	"Operation Wal-RUSH",
	"Operation Blubmarine",
	"Operation Arctic Monocle",
	"Operation F.A.T. (Flippers And Tactics)",
	"Operation Iceberg Lettuce Pray",
	"Operation Mollusk Mayhem",
	"Operation No Tusks Given",
	"Operation Full Flap Jacket",
	"Operation W.A.L.R.U.S. (Weird Amphibious Legion Ready for Unusual Shenanigans)"
]

var emeny_key={
	0:"Orca",
	1:"Orca Jet",
	2:"Crab Missiles"
}

var score_chart={
	0:3,
	1:10,
	2:8
}
var score_list = []
var agent_name=walrus_names.pick_random()

settings={}

func display_full_report():
	misson_report.show()
	for child:Node in misson_report.get_children():
		await get_tree().create_timer(2).timeout 
		bam_soud.play()
		child.show()
		if child.get_script() != null:
			child.display_number()
			await child.finish_display
		


func on_finshed():
	mobile_skip_button.hide()
	skip_label.hide()
	display_full_report()


func _input(event: InputEvent) -> void:
	if (event.is_action("Shoot")and tween!=null):
		if(taps.playing==true):
			taps.stop()
			tween.stop()
			Cam.position=target_position
			on_finshed()
			


func camTween():
	# Get the current camera and create a tween
	tween = create_tween()
	# Tween the camera's position to the target position
	tween.tween_property(Cam, "position", target_position, tween_duration)
	# Optional: You can add easing or other effects to the tween.
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.finished.connect(func ():
		if(OS.has_feature("moblie")):
			mobile_skip_button.show()
		else:
			skip_label.show()
	)

 
func get_total(dic:Dictionary):
	var total:int = 0
	for key in dic.keys():
		total+=dic[key]
	return total
	
func calc_score(dic:Dictionary):
	var total:int = 0
	for key in dic.keys():
		total+=dic[key]*score_chart[key]
	return total

func get_data(uuid,password):
	pass
		
	
func save_online(score:int,cash:int,total_kills:int):
	pass
	


func create_battle_report(kills_dict:Dictionary):
	var random_op = walrus_operations.pick_random()
	var total_kills = get_total(kills_dict)
	var score = calc_score(kills_dict)
	$Control/Mission_Report/Title.text = random_op
	#make the table
	var full_destory_report:Tree = $Control/Mission_Report/Kills
	var root= full_destory_report.create_item()
	var header = root.create_child()
	header.set_text(0,"Enemy")
	header.set_text(1,"Killed")
	for key in kills_dict.keys():
		var row = root.create_child()
		row.set_text(0,emeny_key[key])
		row.set_text(1,str(kills_dict[key]))
	#make the lables
	print(score,total_kills)
	$Control/Mission_Report/Score.set_number(score,2)
	$Control/Mission_Report/TotalKills.set_number(total_kills,2)
	$Control/Mission_Report/Agent.text+=agent_name
	$Control/Mission_Report/Cash.set_number(score*score_to_cash,2)
	
	if(randi_range(0,100)==1):
		$Control/Mission_Report/returnMenu.text="Return To Monkey"
	hide_everything()
	if(get_online_mode()):
		
	write_to_save_file(score,score*score_to_cash,total_kills)
	
	
	
func hide_everything():
	misson_report.hide()
	for object:Node in misson_report.get_children():
		object.hide()
	

func create_grave(kills:int):
	name_label.text=agent_name
	summary_label.text= "In the great battle against the orcas, this noble walrus slew %s before he was sadly felled by an orca." % [str(kills)]
	


func _on_return_menu_pressed() -> void:
		var end_game: Node3D = load("res://Data/Scences/MainMenu.tscn").instantiate()
		self.get_tree().root.get_node("end_game").queue_free()
		self.get_tree().root.add_child(end_game)
		get_tree().current_scene=end_game

func write_to_save_file(score:int,cash:int,total_kills:int):
	var save_game_path="user://user_data//save_data.json"
	var save_file = FileAccess.open(save_game_path,FileAccess.READ)
	var data = JSON.parse_string(save_file.get_as_text())
	print(data)
	data["cash"]+=cash
	data["total_stats"]["cash"]+=cash
	data["total_stats"]["kills"]+=total_kills
	data["total_stats"]["score"]+=score
	print(data)
	save_file.close()
	save_file = FileAccess.open(save_game_path,FileAccess.WRITE)
	save_file.store_string(JSON.stringify(data))
	score_overall=score

func debug_ready():
	var my_dict = {
	 	0: randi() % 100,  # Random number between 0 and 99
	 	1: randi() % 100
	}
	create_battle_report(my_dict)
	create_grave(100)
	
func get_game_server():
	var save_game_path="user://user_data//config.json"
	var save_file = FileAccess.open(save_game_path,FileAccess.READ)
	var data = JSON.parse_string(save_file.get_as_text())
	return data["web_server_address"]
	
func get_online_mode():
	var save_game_path="user://user_data//config.json"
	var save_file = FileAccess.open(save_game_path,FileAccess.READ)
	var data = JSON.parse_string(save_file.get_as_text())
	return data["use_online_mode"]
	
func upload_data(data):
	var http_request:HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	var url = get_game_server()
	var save_game_path="user://user_data//save_data.json"
	var file = FileAccess.open(save_game_path,FileAccess.READ)
	http_request.request_completed.connect(func(result, response_code, headers, body:PackedByteArray):
		print(body.get_string_from_utf8())
		)
	var send = {
		"UUID":"c306bf19-f1e6-4d0e-8a14-1b7476738fd4",
		"password":"1234",
		"data":data
	}
	http_request.request(url+"/upload_data",["Content-Type: application/json"],HTTPClient.METHOD_POST,JSON.stringify(send))
	
signal score_publish_status(status:int)
func publish_score(name:String,score: int):
	var url = get_game_server()
	if url == "":
		push_error("No server address found.")
		return

	var http_request = HTTPRequest.new()
	add_child(http_request)

	# Connect once for ping
	http_request.request_completed.connect(func(result, response_code, headers, body):
		if response_code == 200:
			# Server alive → send score
			var score_request = HTTPRequest.new()
			add_child(score_request)
			
			var json_data = {
				"player_name": name,
				"score": score
			}
			
			score_request.request_completed.connect(func(res, code, h, b):
				print()
				if(code==200):
					score_publish_status.emit(0)
				else:
					score_publish_status.emit(1)
			)
			
			score_request.request(
				url + "/submit_score",
				["Content-Type: application/json"],
				HTTPClient.METHOD_POST,
				JSON.stringify(json_data)
			)
		else:
			score_publish_status.emit(2)
	)

	# First request: ping server
	var err = http_request.request(
		url + "/ping",
		[],
		HTTPClient.METHOD_GET
	)
	if err != OK:
		push_error("Ping request failed to start: %s" % err)


func _ready() -> void:
	update_discordRPC.emit(agent_name)
	mobile_skip_button.pressed.connect(func():
		_on_return_menu_pressed()
		)
	taps.finished.connect(on_finshed)
	randomize()
	camTween()
	debug_ready()


func on_online_submit() -> void:
	var name = $Control/name_menu/name_enter
	publish_score(name.text,score_overall)



func _on_publish_scores_pressed() -> void:
	$Control/name_menu.show()




func _on_score_publish_status(status: int) -> void:
	if status==0:
		$Control/pop_up/Label.text="Scores Submited Correctly"
		$Control/Mission_Report/publish_scores.hide()
	if status==1:
		$Control/pop_up/Label.text="Connected To Server,But unable to submited, Try Again"
	if status==2:
		$Control/pop_up/Label.text="Unable To Connect"
	$Control/pop_up.show()
	$Control/name_menu.hide()
