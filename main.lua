function love.load()
	dofile "map.lua"
	dofile "entity.lua"
	dofile "pos.lua"
	dofile "spawn.lua"
	dofile "fov.lua"
	dofile "input.lua"

	math.randomseed(os.time())
	love.graphics.setNewFont('resources/IBMPlexMono-Light.ttf', 15)

	update_freq = .04
	time_count = 0
	last_key_delay = .3
	last_key_delay_count = 0
	last_key = nil
	entities = {}
	update_all = false

	seen_color = {.3,.3,.3,1}
	visible_color = {1,1,1,1}

	logline = "Welcome to Logue!"

	map = map()
	love.window.setMode(10 + 13 * #map.tiles[1], 40 + 20 * #map.tiles)
	
	player = entity(get_player_spawn(map.rooms), '@', 5, 1, "player")
	table.insert(entities, player)
	output_tiles = map:get_part(pos(1,1), pos(#map.tiles[1], #map.tiles))
	output_tiles = player:draw(output_tiles)

	table.insert(entities, goblin(get_spawn(output_tiles)))
end

function love.update(dt)
	last_key_delay_count = last_key_delay_count + dt
	if time_count <= update_freq then
		time_count = time_count + dt
		return
	end

	output_tiles[player.pos.y][player.pos.x] = map.tiles[player.pos.y][player.pos.x]
	output_tiles = clear_fov(player.pos, output_tiles)

	if love.keyboard.isDown("q") then
		love.event.quit()
	elseif love.keyboard.isDown("j") then
		last_key, last_key_delay_count, logline = move_by_key(player, entities, map, 'j', pos(0, 1), last_key, last_key_delay, last_key_delay_count, output_tiles)	
		update_all = true
	elseif love.keyboard.isDown("k") then
		last_key, last_key_delay_count, logline = move_by_key(player, entities, map, 'k', pos(0, -1), last_key, last_key_delay, last_key_delay_count, output_tiles)
		update_all = true
	elseif love.keyboard.isDown("h") then
		last_key, last_key_delay_count, logline = move_by_key(player, entities, map, 'h', pos(-1, 0), last_key, last_key_delay, last_key_delay_count, output_tiles)
		update_all = true
	elseif love.keyboard.isDown("l") then
		last_key, last_key_delay_count, logline = move_by_key(player, entities, map, 'l', pos(1, 0), last_key, last_key_delay, last_key_delay_count, output_tiles)
		update_all = true
	elseif love.keyboard.isDown("y") then
		last_key, last_key_delay_count, logline = move_by_key(player, entities, map, 'y', pos(-1, -1), last_key, last_key_delay, last_key_delay_count, output_tiles)
		update_all = true
	elseif love.keyboard.isDown("u") then
		last_key, last_key_delay_count, logline = move_by_key(player, entities, map, 'u', pos(1, -1), last_key, last_key_delay, last_key_delay_count, output_tiles)
		update_all = true
	elseif love.keyboard.isDown("b") then
		last_key, last_key_delay_count, logline = move_by_key(player, entities, map, 'b', pos(-1, 1), last_key, last_key_delay, last_key_delay_count, output_tiles)
		update_all = true
	elseif love.keyboard.isDown("n") then
		last_key, last_key_delay_count, logline = move_by_key(player, entities, map, 'n', pos(1, 1), last_key, last_key_delay, last_key_delay_count, output_tiles)
		update_all = true
	else
		last_key = nil
	end
	
	for _,v in pairs(entities) do
		output_tiles[v.pos.y][v.pos.x] = map.tiles[v.pos.y][v.pos.x]
		update_all = false
	end

	if update_all then
		update_entities(player, entities, output_tiles)
	end

	for _,v in pairs(entities) do
		output_tiles = v:draw(output_tiles)
	end

	output_tiles = player:draw(output_tiles)
	output_tiles = fov(player.pos, output_tiles)

	time_count = 0
end

function love.draw()
	love.graphics.print(logline, 10, 10)
	for i,v in ipairs(output_tiles) do
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
