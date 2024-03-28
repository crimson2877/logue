function tile(position, char)
	local tile = {}
	tile.position = position
	tile.char = char
	tile.walkable = false
	tile.seen = false
	tile.visible = false
	return tile
end
