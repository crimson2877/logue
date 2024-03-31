function player(game_state)
	local player = entity(get_player_spawn(game_state.map.rooms), '@', 15, 1, false, "player")
	player.inventory ={}
	function player.pick_item_up(player, item)
		print(item.name)
		table.insert(player.inventory, item)
	end
	return player
end
