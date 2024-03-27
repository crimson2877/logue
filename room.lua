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
