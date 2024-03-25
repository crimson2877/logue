dofile "tile.lua"
dofile "room.lua"
dofile "hall.lua"
dofile "fov.lua"

function create_map()
	local map = {
		height = 25,
		width = 100,
		tiles = {},
		rooms = {},
		halls = {}
	}
	function map:clear_fov()
		for i,v in ipairs(self.tiles) do
			for j,_ in ipairs(v) do
				self.tiles[i][j].visible = false
			end
		end
	end
	function map:make_tiles()
		for i=1,self.height do
			self.tiles[i] = {}
			for j=1,self.width do
				local is_in_room = false
				for k,v in ipairs(self.rooms) do
					if (v:check_if_inside({x = j, y = i})) then
						is_in_room = true
					end
				end
				local is_in_hall = false
				local is_door = false
				for k,v in ipairs(self.halls) do
					local start_point = v[1]
					local end_point = v[get_table_length(v)]
					if (start_point.x == j and 
						start_point.y == i) or 
						(end_point.x == j and 
						end_point.y == i) then
							is_door = true
					end
					if (v:check_inside({x = j, y = i})) then
						is_in_hall = true
					end
				end
				if (is_door) then
					self.tiles[i][j] = create_tile('/', true)
				elseif (is_in_room) then
					self.tiles[i][j] = create_tile('.', true)
				elseif (is_in_hall) then
					self.tiles[i][j] = create_tile('.', true)
				else
					self.tiles[i][j] = create_tile('#', false)
				end
			end
		end
	end

	function room_gen_check(new_room, rooms)
		for j,v in ipairs(rooms) do
			if (v:check_if_intersects(new_room)) then
				return true
			end
		end
	end
	
	function map:generate_rooms()
		local number_of_rooms = 2 --math.random(3, 5)
		for i=1,number_of_rooms do
			local new_room = nil
			local room_intersects = false 
			repeat 
				room_intersects = false
				local room_height = math.random(6, 12)
				local room_width = math.random(6, 12)
				local upper_left_y = math.random(self.height - room_height)
				local upper_left_x = math.random(self.width - room_width)
				
				new_room = create_room({y = upper_left_y, x = upper_left_x}, 
					room_height, 
					room_width)
				
				room_intersects = room_gen_check(new_room, self.rooms)
				

			until (not room_intersects)
			self.rooms[i] = new_room
		end
	end

	local function get_closest_by_index(index, closest_rooms)
		for i,v in ipairs(closest_rooms) do
			if v.index == index then
				return v
			end
		end
	end

	function map:generate_halls()
		local halls_per_room = {}
		local sum = 0
		for i,_ in ipairs(map.rooms) do
			halls_per_room[i] = math.random(1,1)
			sum = sum + halls_per_room[i]
		end
		for i,v in ipairs(map.rooms) do
			local closest_rooms = v:get_closest_rooms(map.rooms)
			for k=0,halls_per_room[i] do
				local closest_room = nil
				local j = 0
				while closest_room == nil and j < get_table_length(halls_per_room) do
					j = j + 1
					closest_room = get_closest_by_index(j, closest_rooms)
					
					if not (halls_per_room[j] ~= nil and
						halls_per_room[j] > 0 and
						closest_room ~= nil and 
						closest_room.dist > 0) then
							closest_room = nil
					end
				end

				if closest_room ~= nil then
					table.insert(map.halls, create_hall(v, 
						map.rooms[closest_room.index]))
					halls_per_room[i] = halls_per_room[i] - 1
					halls_per_room[closest_room.index] = 
						halls_per_room[closest_room.index] - 1
				end
			end
		end
	end

	function map:get_tiles_between(pos1, target)
		local tiles = {}
		local current_pos = pos1
		local min_dist = get_dist_magnitude(current_pos, target)
		repeat 
			local adjacent_coords = get_adjacent_coords(current_pos)
			for i,v in ipairs(adjacent_coords) do
					local dist = get_dist_magnitude(v, target)
					if (dist < min_dist) then
						min_dist = dist
						current_pos = v
					end
			end
			table.insert(tiles, self.tiles[current_pos.y][current_pos.x])
		until min_dist <= 1
		return tiles
	end

	map:generate_rooms()
	map:generate_halls()
	map:make_tiles()
	return map
end
