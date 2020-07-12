extends Sprite

signal pos_updated

remotesync func set_pos(position):
	self.position = position
	emit_signal("pos_updated")
	
