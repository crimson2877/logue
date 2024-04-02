function player(game_state)
	local player = entity(get_player_spawn(game_state.map.rooms), '@', 10, 1, false, "player")
	player.inventory = {}
	player.level = 1
	player.exp = 0
	player.exp_thresh = 100
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
	function player:player_attack(occupant)
		local log = self:attack(occupant)
		if not occupant.alive then
			self.exp = self.exp + occupant.exp_val
			if self.exp >= self.exp_thresh then
				table.insert(game_state.logline, self:level_up())
			end
		end
		return log
	end
	function player:level_up()
		self.level = self.level + 1
		self.exp_thresh = self.exp_thresh + 100 + self.level * 50
		player.dmg = player.dmg + 1
		player.max_hp = player.max_hp + 2
		player.hp = player.hp + 2
		return self.name .. " reached level " .. self.level
	end

	return player
end
