function get_distance(position1, position2)
	return {x = math.abs(position1.x - position2.x), y = math.abs(position1.y - position2.y)}
end
function get_dist_magnitude(position1, position2)
	local dist = get_distance(position1, position2)
	return math.sqrt(dist.x^2 + dist.y^2)
end
function get_vector(position1, position2)
	return {x = position1.x - position2.x, y = position1.y - position2.y}
end
function get_table_length(table)
	local length = 0
	for i,v in ipairs(table) do
		length = length + 1
	end
	return length
end
function get_adjacent_coords(pos)
	local coords = {}
	for i=-1,1 do 
                for j=-1,1 do           
                        table.insert(coords, {x = pos.x + j, y = pos.y + i})
        	end
        end
	return coords
end
