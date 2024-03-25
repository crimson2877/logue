dofile "utility.lua"

function make_fov(player, map)
	local radius = 2

	map.tiles[player.position.y][player.position.x].visible = true
	map.tiles[player.position.y][player.position.x].seen = true
	
	for i=player.position.y - radius,player.position.y + radius - 1 do
		for j=player.position.x - radius,player.position.x + radius - 1 do
			local target = {x = j, y = i}
			local distance = get_dist_magnitude(player.position, target)
			
			if (distance < radius and 
				j < map.width and i < map.height and
				j > 0 and i > 0 and 
				line_of_sight(player, target, map)) then
					map.tiles[i][j].visible = true
					map.tiles[i][j].seen = true
			end
		end
	end
end

function line_of_sight(player, target, map)
	local tiles = map:get_tiles_between(player.position, target)
	local count = 0
	for i,v in ipairs(tiles) do
		if not v.walkable then
			count = count + 1
			if count == 2 then
				return false
			end
		end
	end
	return true
end

