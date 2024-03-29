entity_id = 0

function entity(position, char, hp, dmg, hostile, name)
	local entity = {}
	entity_id = entity_id + 1
	entity.id = entity_id + 1
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
		local tile = tile(self.pos, self.char, self.id)
		tile.walkable = false
		tiles[self.pos.y][self.pos.x] = tile
		return tiles
	end
	
	function entity:attack(occupant)
		occupant.hp = occupant.hp - self.dmg	
		if occupant.hp <= 0 then
			occupant.alive = false
			return occupant.name .. " dies!"
		end
		return occupant.name .. " hit for " .. self.dmg
	end
	return entity
end

function make_enemy(position, char, hp, dmg, name)
	local enemy = entity(
		position,
		char,
		hp,
		dmg,
		true,
		name)

	function enemy:update(player, entities, tiles)
		if is_visible(self.pos, tiles, player.pos) then
			local distance = self.pos:distance_to(player.pos):magnitude()
			local starting_pos = self.pos
			local closest_pos = starting_pos
			for i=-1,1 do
				for j=-1,1 do
					local new_pos = pos(starting_pos.x + j, starting_pos.y + i)
					local new_dist = new_pos:distance_to(player.pos):magnitude()
					if distance > new_dist and map.tiles[new_pos.y][new_pos.x].walkable then
						distance = new_dist
						closest_pos = new_pos
					end
				end
			end
			if (tiles[closest_pos.y][closest_pos.x].occupant == nil) then
				self.pos = pos(closest_pos.x, closest_pos.y)
			else
				self:attack(entities[tiles[closest_pos.y][closest_pos.x].occupant])
			end
		end
	end
	return enemy
end

function goblin(position)
	local goblin = make_enemy(
		position,
		'g',
		2,
		1,
		"goblin")
	return goblin
end

function update_entities(player, entities, tiles)
	for _,v in ipairs(entities) do
		if v.name ~= player.name then
			v:update(player, entities, tiles)
		end
	end
end
