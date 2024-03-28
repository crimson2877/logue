function tile(position, char, occupant)
	local tile = {}
	tile.position = position
	tile.char = char
	tile.occupant = occupant
	tile.walkable = false
	tile.seen = false
	tile.visible = false
	return tile
end
