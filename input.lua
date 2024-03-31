dofile "item.lua"

function love.keypressed(key, isrepeat)
	if game_state.inv_open then
		if keys.inv[key] ~= nil then
		end
	elseif keys.move[key] ~= nil and game_state.player.alive then

		entity_tiles = {}

		table.insert(entity_tiles, game_state.map.tiles[game_state.player.pos.y][game_state.player.pos.x])

		for _,v in ipairs(game_state.entities) do
			if v.alive then
				table.insert(entity_tiles, game_state.map.tiles[v.pos.y][v.pos.x])
			end
		end	

		game_state.output_tiles = clear_fov(game_state.player.pos, game_state.output_tiles)

		move_by_key(game_state, key, keys.move[key])


		game_state.output_tiles = game_state.player:draw(game_state.output_tiles)

		update_entities(game_state)

		for _,v in ipairs(entity_tiles) do
			if not (v.position.x == game_state.player.pos.x and 
				v.position.y == game_state.player.pos.y) then
				game_state.output_tiles[v.position.y][v.position.x] = v
			end
		end
		for _,v in ipairs(game_state.entities) do
			if v.alive and v.id ~= game_state.player.id then
				game_state.output_tiles = v:draw(game_state.output_tiles)
			end
		end

		draw_items(game_state)
		game_state.map:draw_doors(game_state)
		game_state.output_tiles = fov(game_state.player.pos, game_state.output_tiles)

	elseif keys.actions[key] ~= nil then
		if key == 'g' then
			local item = nil
			local item_index = nil
			for i,v in ipairs(game_state.items) do
				if game_state.player.pos.x == v.pos.x and 
					game_state.player.pos.y == v.pos.y then
					item = v
					item_index = i
				end
			end
			if item ~= nil then
				keys.actions[key](game_state.player, item)
				game_state.items[item_index] = nil
			end
		end
	elseif keys.meta[key] ~= nil then
		keys.meta[key](game_state)
	end
end

function move_by_key(game_state, key, delta_pos)
	game_state.logline = game_state.player:move(delta_pos, game_state)
end
