function love.load()
	dofile "map.lua"
	dofile "entity.lua"
	dofile "pos.lua"
	dofile "spawn.lua"

	math.randomseed(os.time())
	update_freq = .2
	time_count = 0
	output_height = 25
	output_width = 50
	map = map()
	player = entity(get_player_spawn(map.rooms), '@', 5, 1)
	output_tiles = map:get_part(pos(1,1), pos(output_width, output_height))
	output_tiles[player.pos.y][player.pos.x] = tile(player.pos, player.char)
end

function love.update(dt)
	if time_count <= update_freq then
		time_count = time_count + dt
		return
	end
	if love.keyboard.isDown("q") then
		love.event.quit()
		time_count = 0
	elseif love.keyboard.isDown("j") then
		player:move(pos(0,1), map)
		time_count = 0
	elseif love.keyboard.isDown("k") then
		player:move(pos(0,-1), map)
		time_count = 0
	elseif love.keyboard.isDown("h") then
		player:move(pos(-1,0), map)
		time_count = 0
	elseif love.keyboard.isDown("l") then
		player:move(pos(1,0), map)
		time_count = 0
	end
	output_tiles = map:get_part(pos(1,1), pos(output_width, output_height))
	output_tiles[player.pos.y][player.pos.x] = tile(player.pos, player.char)
end

function love.draw()
	for i,v in ipairs(output_tiles) do
		for j,w in ipairs(v) do
			love.graphics.print(w.char, 10 + 12 * j, 10 + 20 * i)
		end
	end
end
