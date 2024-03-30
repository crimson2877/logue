function love.keypressed(key, scancode, isrepeat)
	print(isrepeat)
	if keys.move[key] ~= nil then
	
		entity_tiles = {}
	
		table.insert(entity_tiles, game_state.map.tiles[game_state.player.pos.y][game_state.player.pos.x])
		game_state.output_tiles = clear_fov(game_state.player.pos, game_state.output_tiles)
 	
        	for _,v in ipairs(game_state.entities) do
	                table.insert(entity_tiles, game_state.map.tiles[v.pos.y][v.pos.x])
        	end	move_by_key(game_state, key, keys.move[key])

           
	        game_state.output_tiles = game_state.player:draw(game_state.output_tiles)

		update_entities(game_state)
	
        	for _,v in ipairs(entity_tiles) do
                	game_state.output_tiles[v.position.y][v.position.x] = v
	        end
        	   
	        for _,v in ipairs(game_state.entities) do
        	        game_state.output_tiles = v:draw(game_state.output_tiles)
	        end
        	   
        	game_state.output_tiles = fov(game_state.player.pos, game_state.output_tiles)

	elseif keys.meta[key] ~= nil then
		keys.meta[key]()
	end
end

function move_by_key(game_state, key, delta_pos)
	game_state.logline = game_state.player:move(delta_pos, game_state)
end
