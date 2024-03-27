function pos(x, y)
	local position = {x = x, y = y}
	function position:vector_to(end_pos)
		return pos(self.x - end_pos.x, self.y - end_pos.y)
	end
	function position:distance_to(end_pos)
		local vector = self:vector_to(end_pos)
		return pos(math.abs(vector.x), math.abs(vector.y))
	end
	function position:magnitude()
		return math.sqrt(self.x^2 + self.y^2)
	end
	function position:x_dir()
		if self.x > 0 then
			return 1
		elseif self.x == 0 then
			return 0
		else
			return -1
		end
	end
	
	function position:y_dir()
		if self.y > 0 then
			return 1
		elseif self.y == 0 then
			return 0
		else
			return -1
		end
	end
	
	function position:to_string()
		return "(" .. self.x .. ", " .. self.y .. ")"
	end
	return position
end
