function entity(position, char, hp, dmg, hostile)
	local entity = {}
	entity.pos = position
	entity.char = char
	entity.hp = hp
	entity.dmg = dmg
	entity.hostile = hostile or true

	function entity:move(delta_pos, map)
		local final_pos = pos(self.pos.x + delta_pos.x, self.pos.y + delta_pos.y)
		if final_pos.y < #map.tiles and final_pos.y > 0 and
			final_pos.x > 0 and final_pos.x < #map.tiles[1] and 
			map.tiles[final_pos.y][final_pos.x].walkable then
			self.pos.x = self.pos.x + delta_pos.x
			self.pos.y = self.pos.y + delta_pos.y
		end
	end
	
	function entity:draw(tiles)
		local tile = tile(self.pos, self.char, not hostile or 1)
		tile.walkable = false
		tiles[self.pos.y][self.pos.x] = tile
		return tiles
	end
	return entity
end

function goblin(position)
	local goblin = entity(
		position,
		'g',
		2,
		1)
	return goblin
end
