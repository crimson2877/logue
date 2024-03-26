function tile(position, char)
	local tile = {}
	tile.position = position
	tile.char = char
	tile.walkable = false
	return tile
end
