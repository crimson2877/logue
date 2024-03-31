function add_potion_funcs(entity)
	function entity:heal() 
		self.hp = self.hp + 4
	end
	return entity
end
