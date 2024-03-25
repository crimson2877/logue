dofile "map.lua"

function love.load()
	map = map()
	print(map.tiles)
end

function love.draw()
	for i,v in ipairs(map.tiles) do
		for j,w in ipairs(v) do
			love.graphics.print(w.char, 10 + 10 * j, 10 + 10 * i)
		end
	end
end
