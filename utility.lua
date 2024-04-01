function first_index_of(table, value)
	for i,v in pairs(table) do
		if v == value then
			return i
		end
	end
	return nil
end
