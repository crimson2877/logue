function fov(position, tiles)
	local radius = 15
	tiles[position.y][position.x].visible = true
	tiles[position.y][position.x].seen = true
	for i=-1 * radius,radius do
		for j=-1 * radius,radius do
			local target = pos(position.x + j, position.y + i)
			if is_visible(position, tiles, target) then
				tiles[target.y][target.x].visible = true
				tiles[target.y][target.x].seen = true
			end
		end
	end
	return tiles
end

function clear_fov(position, tiles)
	local radius = 15
	for i=-1 * radius,radius do
		for j=-1 * radius,radius do
			local target = pos(position.x + j, position.y + i)
			if (target.y < #tiles and target.x < #tiles[1]) 
				and (target.x > 0 and target.y > 0) then
				tiles[target.y][target.x].visible = false
			end
		end
	end
	return tiles
end

function is_visible(position, tiles, target)
	local distance = position:distance_to(target):magnitude()
	local closest_pos = position
	repeat
		for i=-1,1 do
			for j=-1,1 do
				local new_pos = pos(closest_pos.x + j, closest_pos.y + i)
				local new_dist = new_pos:distance_to(target):magnitude()
				if distance > new_dist then
					distance = new_dist
					closest_pos = new_pos
				end
				if not tiles[new_pos.y][new_pos.x].walkable and distance > 0 then
					return false
				end
			end
		end
	until distance == 0
	return true
end
