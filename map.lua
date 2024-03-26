dofile "tile.lua"
dofile "pos.lua"

function map()
	local map = {}
	map.height = 25
	map.width = 100 
	map.tiles = {}

	for i=0,map.height do
		map.tiles[i] = {}
		for j=0,map.width do
			map.tiles[i][j] = tile(pos(j, i), '#')
		end
	end

	function map:get_part(start_pos, end_pos)
		local map_part = {}
		for i=start_pos.y,end_pos.y do
			table.insert(map_part, {unpack(self.tiles[i], start_pos.x, end_pos.x)})
		end
		return map_part
	end
	return map
end
