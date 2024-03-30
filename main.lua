function love.load(arg)
	dofile "map.lua"
	dofile "entity.lua"
	dofile "pos.lua"
	dofile "spawn.lua"
	dofile "fov.lua"
	dofile "input.lua"

	math.randomseed(os.time())
	love.graphics.setNewFont('resources/IBMPlexMono-Light.ttf', 15)
	love.keyboard.setKeyRepeat(true)

	game_state = {}
	game_state.entities = {}

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
			['q'] = love.event.quit
		}
	}

	seen_color = {.3,.3,.3,1}
	visible_color = {1,1,1,1}

	game_state.logline = "Welcome to Logue!"
	entity_id = 0

	game_state.map = map()
	love.window.setMode(10 + 13 * #game_state.map.tiles[1], 40 + 20 * #game_state.map.tiles)
	
	game_state.player = entity(get_player_spawn(game_state.map.rooms), '@', 5, 1, false, "player")
	table.insert(game_state.entities, game_state.player)

	game_state.output_tiles = game_state.map:get_part(pos(1,1), pos(#game_state.map.tiles[1], #game_state.map.tiles))
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
		love.graphics.print("Game Over!\nYou Died")
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
