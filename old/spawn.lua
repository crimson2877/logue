function get_player_spawn(map)
	local starting_room = map.rooms[1]
	local starting_x = math.random(starting_room.position.x + 2, 
		starting_room.position.x + starting_room.width - 2)
	local starting_y = math.random(starting_room.position.y + 2, 
		starting_room.position.y + starting_room.height - 2)
	return {x = starting_x, y = starting_y}
end
