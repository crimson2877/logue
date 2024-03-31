function love.load(arg)
	dofile "map.lua"
	dofile "entity.lua"
	dofile "pos.lua"
	dofile "spawn.lua"
	dofile "fov.lua"
	dofile "input.lua"
	dofile "item.lua"
	dofile "player.lua"

	math.randomseed(os.time())
	love.graphics.setNewFont('resources/IBMPlexMono-Light.ttf', 15)
	love.keyboard.setKeyRepeat(true)

	game_state = {}
	game_state.entities = {}
	game_state.items = {}
	game_state.inv_open = false
	seen_color = {.3,.3,.3,1}
	visible_color = {1,1,1,1}

	game_state.logline = "Welcome to Logue!"
	entity_id = 0
	load_item_enums()

	game_state.map = map()
	love.window.setMode(10 + 13 * #game_state.map.tiles[1], 40 + 20 * #game_state.map.tiles)
	

	game_state.player = player(game_state)
	table.insert(game_state.entities, game_state.player)

	keys = {
		move = {
			['j'] = pos(0, 1),
			['k'] = pos(0, -1),
			['h'] = pos(-1, 0),
			['l'] = pos(1, 0),
			['y'] = pos(-1, -1),
			['u'] = pos(1, -1),
			['b'] = pos(-1, 1),
			['n'] = pos(1, 1),
			['.'] = pos(0,0)
		},
		meta = {
			['q'] = love.event.quit,
			['i'] = open_inv
		},
		actions = {
			['g'] = game_state.player.pick_item_up,
			['a'] = game_state.player.use_item
		},
	}

	game_state.output_tiles = game_state.map:get_part(pos(1,1), pos(#game_state.map.tiles[1], #game_state.map.tiles))
	game_state.map:draw_doors(game_state)

	spawn_items(game_state)
	draw_items(game_state)

	game_state.output_tiles = game_state.player:draw(game_state.output_tiles)

	for i=1,5 do
		table.insert(game_state.entities, goblin(get_spawn(game_state.output_tiles)))
	end

	for _,v in ipairs(game_state.entities) do
        	game_state.output_tiles = v:draw(game_state.output_tiles)
        end
                   
        game_state.output_tiles = fov(game_state.player.pos, game_state.output_tiles)

end

function love.draw()
	if not game_state.player.alive then
		love.graphics.print("Game Over!\nYou Died", 10, 10)
		return
	elseif game_state.inv_open then
		local inv_string = ""
		for i,v in ipairs(game_state.player.inventory) do
			inv_string = inv_string .. v.name .. "\n"
		end
		love.graphics.print("Inventory:\n" .. inv_string, 10, 10)
		return
	end
	love.graphics.print(game_state.logline or "", 10, 10)
	love.graphics.print("HP: " .. game_state.player.hp, 10, 30)
	for i,v in ipairs(game_state.output_tiles) do
		for j,w in ipairs(v) do
			local color = {0,0,0,0}
			if w.visible then
				color = visible_color
			elseif w.seen then
				color = seen_color
			end
			love.graphics.print({color, w.char}, 10 + (12 * j), 40 + (20 * i))
		end
	end
end
