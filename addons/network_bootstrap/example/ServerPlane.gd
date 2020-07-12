extends Node2D

var _ui_updating = false

func random_vector():
	var pos = Vector2.ZERO
	pos.x = rand_range(0, ProjectSettings.get_setting("display/window/size/width"))
	pos.y = rand_range(0, ProjectSettings.get_setting("display/window/size/height"))
	return pos


func randomize_pos():
	$Chara.rpc("set_pos", random_vector())
	$Chara1.rpc("set_pos", random_vector())
	$Chara2.rpc("set_pos", random_vector())


func _on_Timer_timeout():
	randomize_pos()


func _ready():
	if NetworkBootstrap.is_server():
		get_tree().connect("network_peer_connected", self, "_player_connected")
		$Timer.start()
		randomize_pos()
		$ModeLabel.text = "Server"
	else:
		$ModeLabel.text = "Client"


func _player_connected(id):
	print("New client connected:", id)
	$Chara.rpc_id(id, "set_pos", $Chara.position)
	$Chara1.rpc_id(id, "set_pos", $Chara1.position)
	$Chara2.rpc_id(id, "set_pos", $Chara2.position)
	_ui_notify("NewCon")


func _on_Chara_pos_updated():
	if NetworkBootstrap.is_client():
		_ui_notify("Recv")

func _ui_notify(msg: String):
	if _ui_updating:
		return
	_ui_updating = true
	$StatusLabel.text = msg
	yield(get_tree().create_timer(0.5),"timeout")
	$StatusLabel.text = ""
	_ui_updating = false
