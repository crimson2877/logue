dofile "tile.lua"
dofile "pos.lua"
dofile "hall.lua"
dofile "room.lua"

function map()
	local map = {}
	map.height = 25
	map.width = 75
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
				local is_door = false
				for _,v in pairs(self.rooms) do
					is_in_room = v:is_inside(current_pos) or is_in_room
				end
				for _,v in pairs(self.halls) do
					is_in_hall = v:is_inside(current_pos) or is_in_hall
					if v[1].x == current_pos.x and v[1].y == current_pos.y or
						v[#v].x == current_pos.x and v[#v].y == current_pos.y then
						is_door = true
					end
				end
				if is_door then
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
		for i=0,1 do
			for j=0,2 do
				local x = j * 25 + 1
				local y = i * 12 + 1
				local id
				if i ~= 0 then
					id = j + 2
				elseif i == 0 and j == 1 then
					id = 6
				elseif j == 0 then
					id = 1
				else
					id = 5
				end
				sections[id] = {start_pos = pos(x,y), end_pos = pos(x+25,y+12)}
			end
		end
		for i,section in ipairs(sections) do
			local upper_left = pos(math.random(section.start_pos.x + 2, section.end_pos.x - 5),
				math.random(section.start_pos.y + 2, section.end_pos.y - 5))
			local bot_right = pos(math.random(upper_left.x + 5, section.end_pos.x - 2),
				math.random(upper_left.y + 5, section.end_pos.y - 2))
			self.rooms[i] = room(upper_left, bot_right, section.id)
			if i > 1 then
				table.insert(self.halls, hall(self.rooms[i - 1], self.rooms[i]))
			end
			if i == #sections then
				table.insert(self.halls, hall(self.rooms[i], self.rooms[1]))
				table.insert(self.halls, hall(self.rooms[i], self.rooms[3]))
			end
		end
	end	

	map:gen_rooms()
	map:gen_tiles()
	return map
end

