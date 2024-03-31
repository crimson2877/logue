dofile "item_effects.lua"

function entity(position, char, hp, dmg, hostile, name)
	entity_id = entity_id + 1

	local entity = {}
	entity.id = entity_id
	entity.name = name
	entity.pos = position
	entity.char = char
	entity.hp = hp
	entity.dmg = dmg
	entity.alive = true
	entity.hostile = hostile

	function entity:move(delta_pos, game_state)
		local final_pos = pos(self.pos.x + delta_pos.x, self.pos.y + delta_pos.y)
		local target = game_state.output_tiles[final_pos.y][final_pos.x]
		local logline = ""
		if target.occupant ~= nil then
			logline = self:attack(game_state.entities[target.occupant])
		end
		if final_pos.y < #game_state.output_tiles and final_pos.y > 0 and
			final_pos.x > 0 and final_pos.x < #game_state.output_tiles[1] and 
			game_state.output_tiles[final_pos.y][final_pos.x].walkable then
			self.pos.x = self.pos.x + delta_pos.x
			self.pos.y = self.pos.y + delta_pos.y
		end
		if target.door ~= nil then
			game_state.map.doors[target.door].open = true
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
		if occupant.id == self.id then
			return
		end
		occupant.hp = occupant.hp - self.dmg	
		if occupant.hp <= 0 then
			occupant.alive = false
			return occupant.name .. " dies!"
		end
		return occupant.name .. " hit for " .. self.dmg
	end
	entity = add_potion_funcs(entity)
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

	enemy.item = nil

	function enemy:use_item()
		if self.item ~= nil then
			self.item.func(self)
		end
	end

	function enemy:update(game_state)
		if is_visible(self.pos, game_state.output_tiles, game_state.player.pos) then
			local distance = self.pos:distance_to(game_state.player.pos):magnitude()
			local starting_pos = self.pos
			local closest_pos = starting_pos
			for i=-1,1 do
				for j=-1,1 do
					local new_pos = pos(starting_pos.x + j, starting_pos.y + i)
					local new_dist = new_pos:distance_to(game_state.player.pos):magnitude()
					if distance > new_dist and game_state.map.tiles[new_pos.y][new_pos.x].walkable then
						distance = new_dist
						closest_pos = new_pos
					end
				end
			end
			if (game_state.output_tiles[closest_pos.y][closest_pos.x].occupant == nil) then
				self.pos = pos(closest_pos.x, closest_pos.y)
			else
				self:attack(game_state.entities[game_state.output_tiles[closest_pos.y][closest_pos.x].occupant])
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

function update_entities(game_state)
	for _,v in pairs(game_state.entities) do
		if v.name ~= game_state.player.name and v.alive then
			v:update(game_state)
		end
	end
end
