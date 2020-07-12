tool
extends Node

func _enter_tree():
	get_tree().network_peer = NetworkBootstrap.get_connection_peer()

func _leave_tree():
	get_tree().network_peer = null
