function draw_characters(stdscr, player, characters)
	stdscr:mvaddch(player.position.y, player.position.x, player.char)
	for k,v in pairs(characters) do
		stdscr:mvaddch(v.position.y, v.position.x, v.char)
        end
end

function draw_map(stdscr, map)
	for i,v in ipairs(map.tiles) do
                for j,w in ipairs(v) do
		       stdscr:mvaddch(i, j, w.ch)
                end
        end
end

function draw_all(stdscr, map, player, characters)
        stdscr:clear()
        draw_map(stdscr, map)
        draw_characters(stdscr, player, characters)
end
