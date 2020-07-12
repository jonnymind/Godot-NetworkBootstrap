extends Node


enum ApplicationType {
	APPLICATION_TYPE_SERVER=0,
	APPLICATION_TYPE_CLIENT=1,
	APPLICATION_TYPE_BOTH=2,
}

var application_type = -1 setget set_application_type, get_application_type
var host
var port

var _host_peer
var _client_peer

func get_connection_peer():
	_setup_connection()
	if _client_peer:
		return _client_peer
	return _host_peer


func get_application_type():
	_setup()
	return application_type


func set_application_type(mode: int):
	if mode < 0 or mode > 2:
		return false
	application_type = mode
	return true


func is_server() -> bool:
	"True if this application is in server mode (or in both modes)"
	_setup()
	return application_type == 0 or application_type == 2


func is_client() -> bool:
	"True if this application is in client mode (or in both modes)"
	_setup()
	return application_type == 1 or application_type == 2


func is_server_client() -> bool:
	"True if this application is in server-client mode"
	_setup()
	return application_type == 2

#############################################################
# Private Part
#############################################################

func _setup_connection():
	if _host_peer or _client_peer:
		return
	_setup()
	if is_server() and not _host_peer:
		_create_server(port)
	if is_client() and not _client_peer:
		# Force host to be localhost if in server-client mode
		if is_server_client():
			host = "localhost"
		_create_client(host, port)


func _set_cmdline_param(key, value):
	if key == "--nbs-host":
		host = value
		print("NetworkSetup: Host set to ", host)
	elif key == "--nbs-port":
		port = int(value)
		print("NetworkSetup: Port set to ", port)
	elif key == "--nbs-type":
		var at = int(value)
		if at >= 0 and at <= 2:
			application_type = at
			print("NetworkSetup: Application type set to ", at)


func _setup():
	# Already configured?
	if application_type >= 0 and host and port:
		return 
	
	# Allow programmatic override
	if application_type == -1:
		application_type = ProjectSettings.get("application/network/application_type")
	if not host:
		host = ProjectSettings.get("application/network/host")
	if not port:
		port = ProjectSettings.get("application/network/port")
	
	# Override project configuration with command line.
	if ProjectSettings.get("application/network/allow_cmd_line"):
		_setup_cmdl()


func _setup_cmdl():
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			_set_cmdline_param(key_value[0], key_value[1])


func _create_server(port):
	_host_peer = NetworkedMultiplayerENet.new()
	_host_peer.create_server(port)


func _create_client(host, port):
	_client_peer = NetworkedMultiplayerENet.new()
	_client_peer.create_client(host, port)

