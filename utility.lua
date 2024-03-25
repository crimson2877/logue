function get_distance(position1, position2)
	return {x = math.abs(position1.x - position2.x), y = math.abs(position1.y - position2.y)}
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
