local curses = require "curses"

function draw_characters(stdscr, player, characters)
	stdscr:mvaddch(player.position.y, player.position.x, player.char)
	for k,v in pairs(characters) do
		stdscr:mvaddch(v.position.y, v.position.x, v.char)
        end
end

function draw_map(stdscr, map)
	for i,v in ipairs(map.tiles) do
                for j,w in ipairs(v) do
			if (map.tiles[i][j].visible == true) then
				stdscr:attron(curses.color_pair(1))
		       		stdscr:mvaddch(i, j, w.ch)
				stdscr:attroff(curses.color_pair(1))
			elseif (map.tiles[i][j].seen == true) then
				stdscr:attron(curses.color_pair(2))
				stdscr:mvaddch(i, j, w.ch)
				stdscr:attroff(curses.color_pair(2))
			end
                end
        end
end

function draw_all(stdscr, map, player, characters)
        stdscr:clear()
        draw_map(stdscr, map)
        draw_characters(stdscr, player, characters)
end
