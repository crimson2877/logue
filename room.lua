dofile "utility.lua"

function create_room(position, height, width)
	local room = {
		position = position, --upper left corner
		height = height,
		width = width
	}
	function room:get_center()
		return {x = self.position.x + (width / 2), y = self.position.y + (height / 2)}
	end
	function room:check_if_inside(position)
		if (position.x > self.position.x and position.x < self.position.x + self.width and 
			position.y > self.position.y and position.y < self.position.y + self.height) then
			return true
		end
	end
	function room:check_if_near(position)
		if (position.x + 2 >= self.position.x and 
			position.x - 2 <= self.position.x + self.width and 
			position.y + 2 >= self.position.y and 
			position.y - 2 <= self.position.y + self.height) then
				return true
		end
	end
	function room:check_if_intersects(new_room)
		local corner_check = self:check_if_near(new_room.position) or
                       	self:check_if_near({x = new_room.position.x + new_room.width,
                        	y = new_room.position.y + new_room.height}) or
                        self:check_if_near({x = new_room.position.x,
                        	y = new_room.position.y + new_room.height}) or
                        self:check_if_near({x = new_room.position.x + new_room.width,
                        	y = new_room.position.y})
				
		local intersect_check = (new_room.position.x < self.position.x and 
			new_room.position.x + new_room.width > self.position.x + self.width and
			new_room.position.y > self.position.y and
                        new_room.position.y + new_room.height < self.position.y + self.height) or
			(new_room.position.y < self.position.y and 
			new_room.position.y + new_room.height > self.position.y + self.height and
			new_room.position.x > self.position.x and
                        new_room.position.x + new_room.width < self.position.x + self.width) 

		return corner_check or intersect_check
	end
	function room:get_closest_rooms(rooms)
		local distances = {}
		for i,v in ipairs(rooms) do
			local center_dist = get_distance(self:get_center(), v:get_center())
			distances[i] = {index = i, dist = center_dist.x + center_dist.y}
		end
		table.sort(distances, function (a,b) return a.dist < b.dist end)
		return distances
	end
	return room
end
