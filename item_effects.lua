function add_potion_funcs(entity)
	function entity:heal() 
		self.hp = self.hp + 4
		if (self.hp > self.max_hp) then
			self.hp = self.max_hp
		end
	end
	return entity
end
