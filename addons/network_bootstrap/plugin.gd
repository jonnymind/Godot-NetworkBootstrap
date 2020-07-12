tool
extends EditorPlugin

const icon = preload("res://addons/network_bootstrap/icon.png")
const networkLinkIcon = preload("res://addons/network_bootstrap/serverClientIcon.png")
const networkLinkScript = preload("res://addons/network_bootstrap/network_link.gd")


func _enter_tree():
	ProjectSettings.set("application/network/application_type", 0)
	ProjectSettings.set("application/network/host", "localhost")
	ProjectSettings.set("application/network/port", 8089)
	ProjectSettings.set("application/network/allow_cmd_line", true)
	
	var property_info = {
		"name": "application/network/application_type",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Server,Client,Both"
	}
	ProjectSettings.add_property_info(property_info)
	add_autoload_singleton("NetworkBootstrap", "res://addons/network_bootstrap/network_bootstrap.gd")
	add_custom_type("NetworkLink", "Node", networkLinkScript, networkLinkIcon )


func _exit_tree():
	remove_custom_type("NetworkLink")
	remove_autoload_singleton("NetworkBootstrap")


func get_plugin_name():
	return "NetworkBootstrap"


func get_plugin_icon():
	return icon
