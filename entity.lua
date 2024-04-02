dofile "item_effects.lua"

function entity(position, char, hp, dmg, hostile, name)
	entity_id = entity_id + 1

	local entity = {}
	entity.id = entity_id
	entity.name = name
	entity.pos = position
	entity.char = char
	entity.hp = hp
	entity.max_hp = hp
	entity.dmg = dmg
	entity.alive = true
	entity.hostile = hostile

	function entity:move(delta_pos, game_state)
		local final_pos = pos(self.pos.x + delta_pos.x, self.pos.y + delta_pos.y)
		local target = game_state.output_tiles[final_pos.y][final_pos.x]
		local logline = ""
		if target.occupant ~= nil and not (delta_pos.x == 0 and delta_pos.y == 0) then
			if self.id == game_state.player.id then
				logline = self:player_attack(game_state.entities[target.occupant])
			else
				logline = self:attack(game_state.entities[target.occupant])
			end
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
		tile.transparent = true
		if (self.alive) then
			tiles[self.pos.y][self.pos.x] = tile
		end
		return tiles
	end
	
	function entity:attack(occupant)
		if occupant.id == self.id then
			return
		elseif occupant.id == game_state.player.id then
			game_state.player.hp = game_state.player.hp - self.dmg
			return game_state.player.name .. " hit for " .. self.dmg
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

function make_enemy(position, char, hp, dmg, name, exp_val)
	local enemy = entity(
		position,
		char,
		hp,
		dmg,
		true,
		name)

	enemy.item = nil
	enemy.exp_val = exp_val

	function enemy:use_item()
		if self.item ~= nil then
			self.item.func(self)
		end
	end

	function enemy:update(game_state)
		if is_visible(self.pos, game_state.output_tiles, game_state.player.pos) and self.alive then
			local distance = self.pos:distance_to(game_state.player.pos):magnitude()
			local starting_pos = self.pos
			local closest_pos = starting_pos
			for i=-1,1 do
				for j=-1,1 do
					local new_pos = pos(starting_pos.x + j, starting_pos.y + i)
					local new_dist = new_pos:distance_to(game_state.player.pos):magnitude()
					local new_tile = game_state.output_tiles[new_pos.y][new_pos.x]
					if distance > new_dist and (new_tile.walkable or new_tile.occupant) then
						distance = new_dist
						closest_pos = new_pos
					end
				end
			end
			if (game_state.output_tiles[closest_pos.y][closest_pos.x].occupant == nil) then
				self.pos = pos(closest_pos.x, closest_pos.y)
			else
				local log = self:attack(game_state.entities[game_state.output_tiles[closest_pos.y][closest_pos.x].occupant])
				print(log)
				table.insert(game_state.logline, log)
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
		"goblin",
		12)
	return goblin
end

function update_entities(game_state)
	for _,v in pairs(game_state.entities) do
		if v.id ~= game_state.player.id and v.alive then
			v:update(game_state)
		end
	end
end
