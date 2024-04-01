function player(game_state)
	local player = entity(get_player_spawn(game_state.map.rooms), '@', 15, 1, false, "player")
	player.inventory = {}
	player.fund = 0
	function player:pick_item_up(item)
		if item.item_type == item_type_enum.gold then
			self.fund = self.fund + item.func
		else
			table.insert(player.inventory, item)
		end
	end
	function player:use_item(item)
		item.func(self)
	end
	return player
end
