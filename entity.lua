function entity(position, char, hp, dmg)
	local entity = {}
	entity.pos = position
	entity.char = char
	entity.hp = hp
	entity.dmg = dmg

	function entity:move(delta_pos)
		self.pos.x = self.pos.x + delta_pos.x
		self.pos.y = self.pos.y + delta_pos.y
	end
	return entity
end
