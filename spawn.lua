dofile "pos.lua"

function get_player_spawn(rooms)
	local spawn_room = rooms[math.random(1, #rooms)]
	return pos(math.random(spawn_room.top_left.x + 1, spawn_room.bot_right.x - 1), 
		math.random(spawn_room.top_left.y + 1, spawn_room.bot_right.y - 1))
end
