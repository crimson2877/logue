function love.load(arg)
	dofile "map.lua"
	dofile "entity.lua"
	dofile "pos.lua"
	dofile "spawn.lua"
	dofile "fov.lua"
	dofile "input.lua"
	dofile "item.lua"
	dofile "player.lua"
	dofile "utility.lua"

	math.randomseed(os.time())
	love.graphics.setNewFont('resources/IBMPlexMono-Light.ttf', 15)
	love.keyboard.setKeyRepeat(true)

	game_state = {}
	game_state.entities = {}
	game_state.items = {}
	game_state.floor = 1
	game_state.inv_open = false
	seen_color = {.3,.3,.3,1}
	visible_color = {1,1,1,1}

	game_state.logline = {"Welcome to Logue!"}
	entity_id = 0
	load_item_enums()

	game_state.map = map()
	love.window.setMode(10 + 13 * #game_state.map.tiles[1], 70 + 20 * #game_state.map.tiles)
	
	window_height = 70 + 20 * #game_state.map.tiles

	game_state.player = player(game_state)
	table.insert(game_state.entities, game_state.player)

	game_state.output_tiles = game_state.map:get_part(pos(1,1), pos(#game_state.map.tiles[1], #game_state.map.tiles))
	game_state.map:draw_doors(game_state)

	spawn_items(game_state)
	draw_items(game_state)

	game_state.output_tiles = game_state.player:draw(game_state.output_tiles)

	for i=1,5 do
		table.insert(game_state.entities, goblin(get_spawn(game_state.output_tiles)))
	end

	for _,v in pairs(game_state.entities) do
        	game_state.output_tiles = v:draw(game_state.output_tiles)
        end
                   
        game_state.output_tiles = fov(game_state.player.pos, game_state.output_tiles)
	dofile "keys.lua"

end

function love.draw()
	if not game_state.player.alive then
		love.graphics.print("Game Over!\nYou Died", 10, 10)
		return
	elseif game_state.inv_open then
		local inv_string = ""
		for i,v in pairs(game_state.player.inventory) do
			inv_string = inv_string .. "(" .. first_index_of(keys.inv, i) .. ") " .. v.name .. "\n"
		end
		love.graphics.print("Inventory:\tGold: " .. game_state.player.fund .. "\n" .. inv_string, 10, 10)
		return
	end
	love.graphics.print(game_state.logline[#game_state.logline] or "", 10, 40)
	love.graphics.print(game_state.logline[#game_state.logline - 1] or "", 10, 25)
	love.graphics.print(game_state.logline[#game_state.logline - 2] or "", 10, 10)
	for i,v in ipairs(game_state.output_tiles) do
		for j,w in ipairs(v) do
			local color = {0,0,0,0}
			if w.visible then
				if w.color ~= nil then
					color = w.color 
				else
					color = visible_color
				end
			elseif w.seen then
				if w.color ~= nil then
					color = {w.color[1] * .4, w.color[2] * .4, w.color[3] * .4, 1} 
				else
					color = seen_color
				end
			end
			love.graphics.print({color, w.char}, 10 + (12 * j), 40 + (20 * i))
		end
	end
	love.graphics.print("HP: " .. game_state.player.hp .. "\t Floor: " .. game_state.floor .. "\t Level: " .. game_state.player.level .. " Exp: " .. game_state.player.exp, 10, window_height - 30)
end
