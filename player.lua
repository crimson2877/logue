function player(game_state)
	local player = entity(get_player_spawn(game_state.map.rooms), '@', 15, 1, false, "player")
	player.inventory = {}
	function player:pick_item_up(item)
		table.insert(player.inventory, item)
	end
	function player:use_item(item)
		item.func(self)
	end
	return player
end
