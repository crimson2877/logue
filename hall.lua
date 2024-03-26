function hall(start_room, end_room)
	local room_dist_vector = start_room.top_left:vector_to(end_room.top_left)
	local x_dir = -1 * room_dist_vector:x_dir()
	local y_dir = -1 * room_dist_vector:y_dir()
	local start_pos
	local second_pos
	local end_pos
	local penult_pos
	local hall = {}

	if math.abs(room_dist_vector.x) > math.abs(room_dist_vector.y) then
		local room_x_dir = (x_dir + 1) / 2
		start_pos = pos(start_room.top_left.x + (room_x_dir * start_room:width()), 
					math.random(start_room.top_left.y + 1, start_room.bot_right.y - 1))
		end_pos = pos(end_room.top_left.x + (-1 * room_x_dir * end_room:width()), 
					math.random(end_room.top_left.y + 1, end_room.bot_right.y - 1))
		second_pos = pos(start_pos.x + x_dir, start_pos.y)
		penult_pos = pos(end_pos.x + -1 * x_dir, end_pos.y)
	else
		local room_y_dir = (y_dir + 1) / 2
		start_pos = pos(math.random(start_room.top_left.x + 1, start_room.bot_right.x - 1),
					start_room.top_left.y + (room_y_dir * start_room:height()))
		end_pos = pos(math.random(end_room.top_left.x + 1, end_room.bot_right.x - 1),
			end_room.top_left.y + (-1 * room_y_dir * end_room:height()))
		second_pos = pos(start_pos.x, start_pos.y + y_dir)
		penult_pos = pos(end_pos.x, end_pos.y + -1 * y_dir)
	end

	local hall_dist = second_pos:distance_to(penult_pos)
	table.insert(hall, start_pos)
	table.insert(hall, second_pos)

	repeat
		local last_pos = hall[#hall]
		local new_pos
		if hall_dist.x > 0 and (math.random(-1, 1) > 0 or hall_dist.y == 0) then
			new_pos = pos(last_pos.x + x_dir, last_pos.y)
			hall_dist.x = hall_dist.x - 1
		else
			new_pos = pos(last_pos.x, last_pos.y + y_dir)
			hall_dist.y = hall_dist.y - 1
		end
		table.insert(hall, new_pos)
	until hall_dist.x + hall_dist.y == 0

	table.insert(hall, penult_pos)
	table.insert(hall, end_pos)

	function hall:is_inside(pos)
		for _,v in ipairs(hall) do
			if v.x == pos.x and v.y == pos.y then
				return true
			end
		end
		return false
	end

	return hall
end
