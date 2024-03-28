function love.load()
	dofile "map.lua"
	dofile "entity.lua"
	dofile "pos.lua"
	dofile "spawn.lua"

	math.randomseed(os.time())
	love.graphics.setNewFont('resources/IBMPlexMono-Light.ttf', 18)

	update_freq = .04
	time_count = 0
	last_key_delay = .3
	last_key_delay_count = 0
	last_key = nil

	map = map()
	love.window.setMode(20 + 15 * #map.tiles[1], 20 + 25 * #map.tiles)
	player = entity(get_player_spawn(map.rooms), '@', 5, 1)
	output_tiles = map:get_part(pos(1,1), pos(#map.tiles[1], #map.tiles))
	output_tiles[player.pos.y][player.pos.x] = tile(player.pos, player.char)
end

function love.update(dt)
	last_key_delay_count = last_key_delay_count + dt
	if time_count <= update_freq then
		time_count = time_count + dt
		return
	end
	if love.keyboard.isDown("q") then
		love.event.quit()
	elseif love.keyboard.isDown("j") then
		if last_key ~= 'j' or (last_key == 'j' and last_key_delay_count >= last_key_delay) then
			player:move(pos(0,1), map)
			if last_key ~= 'j' then
				last_key_delay_count = 0
			end
			last_key = 'j'
		end
	elseif love.keyboard.isDown("k") then
		if last_key ~= 'k' or (last_key == 'k' and last_key_delay_count >= last_key_delay) then
			player:move(pos(0,-1), map)
			if last_key ~= 'k' then
				last_key_delay_count = 0
			end
			last_key = 'k'
		end
	elseif love.keyboard.isDown("h") then
		if last_key ~= 'h' or (last_key == 'h' and last_key_delay_count >= last_key_delay) then
			player:move(pos(-1,0), map)
			if last_key ~= 'h' then
				last_key_delay_count = 0
			end
			last_key = 'h'
		end
	elseif love.keyboard.isDown("l") then
		if last_key ~= 'l' or (last_key == 'l' and last_key_delay_count >= last_key_delay) then
			player:move(pos(1,0), map)
			if last_key ~= 'l' then
				last_key_delay_count = 0
			end
			last_key = 'l'
		end
	elseif love.keyboard.isDown("y") then
		if last_key ~= 'y' or (last_key == 'y' and last_key_delay_count >= last_key_delay) then
			player:move(pos(-1,-1), map)
			if last_key ~= 'y' then
				last_key_delay_count = 0
			end
			last_key = 'y'
		end
	elseif love.keyboard.isDown("u") then
		if last_key ~= 'u' or (last_key == 'u' and last_key_delay_count >= last_key_delay) then
			player:move(pos(1,-1), map)
			if last_key ~= 'u' then
				last_key_delay_count = 0
			end
			last_key = 'u'
		end
	elseif love.keyboard.isDown("b") then
		if last_key ~= 'b' or (last_key == 'b' and last_key_delay_count >= last_key_delay) then
			player:move(pos(-1,1), map)
			if last_key ~= 'b' then
				last_key_delay_count = 0
			end
			last_key = 'b'
		end
	elseif love.keyboard.isDown("n") then
		if last_key ~= 'n' or (last_key == 'n' and last_key_delay_count >= last_key_delay) then
			player:move(pos(1,1), map)
			if last_key ~= 'n' then
				last_key_delay_count = 0
			end
			last_key = 'n'
		end
	else
		last_key = nil
	end
	time_count = 0
	output_tiles = map:get_part(pos(1,1), pos(#map.tiles[1], #map.tiles))
	output_tiles[player.pos.y][player.pos.x] = tile(player.pos, player.char)
end

function love.draw()
	for i,v in ipairs(output_tiles) do
		for j,w in ipairs(v) do
			love.graphics.print(w.char, 10 + 12 * j, 10 + 20 * i)
		end
	end
end
