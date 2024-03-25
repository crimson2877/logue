dofile "utility.lua"

function create_hall(start_room, end_room)
	local center_distance = get_vector(start_room:get_center(), end_room:get_center())
	local x_dir = (-1 * center_distance.x) / math.abs(center_distance.x)
	local y_dir = (-1 * center_distance.y) / math.abs(center_distance.y)
	local start_point
	local end_point
	local distance = {}
	local length
	local hall = {}

	if (math.random(-1, 1) > 0) then
		start_point = {
			x = start_room:get_center().x + (x_dir * start_room.width / 2),
			y = start_room.position.y + math.random(start_room.height)
		}
		hall[1] = start_point
		hall[2] = {x = start_point.x + x_dir, y = start_point.y}
	else
		start_point = {                                                     
                        y = start_room:get_center().y + (y_dir * start_room.height / 2),
                        x = start_room.position.x + math.random(start_room.width)
                }
		hall[1] = start_point
		hall[2] = {x = start_point.x, y = start_point.y + y_dir}
	end

	if (math.random(-1, 1) > 0) then
		end_point = {
			x = end_room:get_center().x + (-1 * x_dir * end_room.width / 2),
			y = end_room.position.y + math.random(end_room.height)
		}
		distance = get_distance(start_point, end_point)
		length = distance.x + distance.y
		hall[length] = end_point
		hall[length - 1] = {x = end_point.x + (x_dir * -1), y = end_point.y}
	else
		end_point = {                                                     
                        y = end_room:get_center().y + (-1 * y_dir * end_room.height / 2),
                        x = end_room.position.x + math.random(end_room.width) 
                }
		distance = get_distance(start_point, end_point)
		length = distance.x + distance.y
		hall[length] = end_point
		hall[length - 1] = {x = end_point.x, y = end_point.y + (y_dir * -1)}
	end
	print("length:")
	print(length)
	local leftover_distance = get_distance(hall[2], hall[length - 1])
	leftover_distance.x = leftover_distance.x + 1
	leftover_distance.y = leftover_distance.y + 1
	print "new hall"
	local i = 3
	repeat
		print("newline")
		print(i)
		print(length)
		print(leftover_distance.x + leftover_distance.y)
		if (leftover_distance.x > 0 and (math.random(-1, 1) > 0 or leftover_distance.y == 0)) then
			hall[i] = {x = hall[i - 1].x + x_dir, y = hall[i - 1].y}
			leftover_distance.x = leftover_distance.x - 1
		elseif (leftover_distance.y > 0) then
			hall[i] = {x = hall[i - 1].x, y = hall[i - 1].y + y_dir}
			leftover_distance.y = leftover_distance.y - 1
		end
		i = i + 1
	until (leftover_distance.x + leftover_distance.y == 0)
	print("done")
	function hall:check_inside(position)
		for i,v in ipairs(self) do
			if v.x == position.x and v.y == position.y then
				return true
			end
		end
		return false
	end
	return hall
end
