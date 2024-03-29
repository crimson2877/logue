function entity(position, char, hp, dmg, hostile, name)
	local entity = {}
	entity.name = name
	entity.pos = position
	entity.char = char
	entity.hp = hp
	entity.dmg = dmg
	entity.alive = true
	entity.hostile = hostile or true

	function entity:move(delta_pos, entities, tiles, map)
		local final_pos = pos(self.pos.x + delta_pos.x, self.pos.y + delta_pos.y)
		local occupant = tiles[final_pos.y][final_pos.x].occupant
		local logline = ""
		if occupant ~= nil then
			logline = self:attack(entities[occupant])
			if not entities[occupant].alive then
				entities[occupant] = nil
				tiles[final_pos.y][final_pos.x] = map.tiles[final_pos.y][final_pos.x]
			end
		end
		if final_pos.y < #tiles and final_pos.y > 0 and
			final_pos.x > 0 and final_pos.x < #tiles[1] and 
			tiles[final_pos.y][final_pos.x].walkable then
			self.pos.x = self.pos.x + delta_pos.x
			self.pos.y = self.pos.y + delta_pos.y
		end
		return logline
	end
	
	function entity:draw(tiles)
		local entity_id = nil
		if self.hostile then
			entity_id = 1
		end
		local tile = tile(self.pos, self.char, entity_id)
		tile.walkable = false
		tiles[self.pos.y][self.pos.x] = tile
		return tiles
	end
	
	function entity:attack(occupant)
		occupant.hp = occupant.hp - self.dmg	
		if occupant.hp <= 0 then
			occupant.alive = false
		end
		return occupant.name .. " hit for " .. self.dmg
	end
	return entity
end

function goblin(position)
	local goblin = entity(
		position,
		'g',
		2,
		1,
		true,
		"goblin")
	print(goblin.name)
	return goblin
end
