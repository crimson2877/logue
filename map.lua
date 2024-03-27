dofile "tile.lua"
dofile "pos.lua"
dofile "hall.lua"

function map()
	local map = {}
	map.height = 25
	map.width = 50 
	map.tiles = {}
	map.rooms = {}
	map.halls = {}

	function map:gen_tiles()
		for i=1,self.height do
			self.tiles[i] = {}
			for j=1,self.width do
				local current_pos = pos(j, i)
				local is_in_room = false
				local is_in_hall = false
				for k,v in pairs(self.rooms) do
					is_in_room = v:is_inside(current_pos) or is_in_room
				end
				for k,v in pairs(self.halls) do
					is_in_hall = v:is_inside(current_pos) or is_in_hall
				end
				if is_in_room and is_in_hall then
					map.tiles[i][j] = tile(current_pos, '/')
					map.tiles[i][j].walkable = true
				elseif is_in_room or is_in_hall then
					map.tiles[i][j] = tile(current_pos, '.')
					map.tiles[i][j].walkable = true
				else
					map.tiles[i][j] = tile(current_pos, '#')
				end
			end
		end
	end

	function map:get_part(start_pos, end_pos)
		local map_part = {}
		for i=start_pos.y,end_pos.y do
			table.insert(map_part, {unpack(self.tiles[i], start_pos.x, end_pos.x)})
		end
		return map_part
	end
	function map:gen_rooms()
		local sections = {}
		for i=0,self.height/12 - 1 do
			for j=0,self.width/25 - 1 do
				local x = j * 25 + 1
				local y = i * 12 + 1
				table.insert(sections, {id = pos(j + 1,i + 1), start_pos = pos(x,y), end_pos = pos(x+25,y+12)})
			end
		end
		local num_of_rooms = math.random(2, #sections - 1)
		for i=1,num_of_rooms do
			local section_index = math.random(1, #sections)
			local section = sections[section_index]
			local upper_left = pos(math.random(section.start_pos.x + 1, section.end_pos.x - 5),
				math.random(section.start_pos.y + 1, section.end_pos.y - 5))
			local bot_right = pos(math.random(upper_left.x + 5, section.end_pos.x - 2),
				math.random(upper_left.y + 5, section.end_pos.y - 1))
			self.rooms[section.id:to_string()] = room(upper_left, bot_right, section.id)
			table.remove(sections, section_index)
		end
	end	

	function map:gen_halls()
		local hall_exists = {}
		for k,v in pairs(self.rooms) do
			local left = pos(v.id.x - 1, v.id.y)
			local right = pos(v.id.x + 1, v.id.y)
			local up = pos(v.id.x, v.id.y - 1)
			local down = pos(v.id.x, v.id.y + 1)
			print(k)
			print(right:to_string())
			print(self.rooms[right:to_string()])
			print(hall_exists[k])

			if self.rooms[left:to_string()] ~= nil and (hall_exists[k] ~= nil and hall_exists[k][left:to_string()] == nil) then
				print("test")
				table.insert(self.halls, hall(v, self.rooms[left:to_string()]))
				hall_exists[left:to_string()][k] = true
			end
			if self.rooms[right:to_string()] ~= nil and (hall_exists[k] ~= nil and hall_exists[k][right:to_string()] == nil) then
				print("tesdt")
				table.insert(self.halls, hall(v, self.rooms[right:to_string()]))
				hall_exists[right:to_string()][k] = true
			end
			if self.rooms[up:to_string()] ~= nil and (hall_exists[k] ~= nil and hall_exists[k][up:to_string()] == nil) then
				print("tesdt")
				table.insert(self.halls, hall(v, self.rooms[up:to_string()]))
				hall_exists[up:to_string()][k] = true
			end
			if self.rooms[down:to_string()] ~= nil and (hall_exists[k] ~= nil and hall_exists[k][down:to_string()] == nil) then
				print("tesdt")
				table.insert(self.halls, hall(v, self.rooms[down:to_string()]))
				hall_exists[down:to_string()][k] = true
			end
		end
	end

	map:gen_rooms()
	map:gen_halls()
	map:gen_tiles()
	return map
end
function room(top_left, bot_right, id)
	local room = {}
	room.top_left = top_left
	room.bot_right = bot_right
	room.id = id
	function room:is_inside(pos)
		if (pos.x > self.top_left.x and pos.x < self.bot_right.x and
			pos.y > self.top_left.y and pos.y < self.bot_right.y) then
			return true
		end
		return false
	end
	function room:height()
		return math.abs(self.top_left.y - self.bot_right.y)
	end
	function room:width()
		return math.abs(self.top_left.x - self.bot_right.x)
	end
	return room
end
