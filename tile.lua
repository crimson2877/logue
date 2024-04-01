function tile(position, char, occupant)
	local tile = {}
	tile.position = position
	tile.char = char
	tile.occupant = occupant
	tile.item = nil
	tile.door = nil
	tile.stair = false
	tile.walkable = false
	tile.seen = false
	tile.visible = false
	tile.color = nil
	return tile
end
