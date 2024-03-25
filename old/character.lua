function init_character(position, hp, dmg, char)
	local character = {
		position = position,
		hp = hp,
		dmg = dmg,
		char = char
	}

	function character:is_touching(other_character)
		return 
			math.abs(self.position.x - other_character.position.x) == 1 or 
			math.abs(self.position.y - other_character.position.y) == 1 
	end

	function character:move(x, y, map)
		if (map.tiles[self.position.y + y][self.position.x + x].walkable) then
			self.position.x = self.position.x + x
			self.position.y = self.position.y + y
		end
	end
	return character
end
