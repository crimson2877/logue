dofile "tile.lua"
dofile "pos.lua"
dofile "hall.lua"
dofile "room.lua"
dofile "door.lua"

function map()
	local map = {}
	map.height = 25
	map.width = 75
	map.tiles = {}
	map.rooms = {}
	map.halls = {}
	map.doors = {}
	map.stair = nil

	function map:gen_tiles()
		for i=1,self.height do
			self.tiles[i] = {}
			for j=1,self.width do
				local current_pos = pos(j, i)
				local is_in_room = false
				local is_in_hall = false

				for _,v in pairs(self.rooms) do
					is_in_room = v:is_inside(current_pos) or is_in_room
				end
				for _,v in pairs(self.halls) do
					is_in_hall = v:is_inside(current_pos) or is_in_hall
				end

				if is_in_room or is_in_hall then
					self.tiles[i][j] = tile(current_pos, '.')
					self.tiles[i][j].walkable = true
				else
					self.tiles[i][j] = tile(current_pos, '#')
				end
			end
		end
		local stair_tile = tile(self.stair, '>')
		stair_tile.stair = true
		stair_tile.walkable = true
		self.tiles[self.stair.y][self.stair.x] = stair_tile
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

		for i,v in ipairs(self.halls) do
			table.insert(self.doors, door(v[1]))
			table.insert(self.doors, door(v[#v]))
		end
	end	

	function map:draw_doors(game_state)
		for i,v in ipairs(self.doors) do
			local tile = tile(v.pos, '+')
			tile.door = i
			if v.open then
				tile.walkable = true
				tile.char = '/'
			end
			if not (v.pos.y == game_state.player.pos.y and v.pos.x == game_state.player.pos.x) then
				game_state.output_tiles[v.pos.y][v.pos.x] = tile 
			end
		end
	end

	function map:gen_stair()
		local room = self.rooms[math.random(1, #self.rooms)]
		self.stair = pos(math.random(room.top_left.x + 1, room.bot_right.x - 1), 
			math.random(room.top_left.y + 1, room.bot_right.y - 1))
	end

	map:gen_rooms()
	map:gen_stair()
	map:gen_tiles()
	return map
end

