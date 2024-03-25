dofile "tile.lua"
dofile "pos.lua"

function map()
	local map = {}
	map.height = 25
	map.width = 75
	map.tiles = {}

	for i=0,map.height do
		map.tiles[i] = {}
		for j=0,map.width do
			map.tiles[i][j] = tile(pos(j, i), '#')
		end
	end
	return map
end
