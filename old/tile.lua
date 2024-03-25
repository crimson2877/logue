function create_tile(ch, walkable, blocks_sight)
	local tile = {
		ch = ch,
		walkable = walkable,
		visible = false,
		seen = false
	}
	return tile
end
