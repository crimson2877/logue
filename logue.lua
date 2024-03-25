local curses = require "curses"
local getch = require "lua-getch"
dofile("character.lua")
dofile("enemy.lua")
dofile("map.lua")
dofile("draw.lua")
dofile("spawn.lua")

local function create_player(position)
	local new_player = init_character( 
		position,
		5,
		1,
		'@'
	)
	return new_player
end

local function handle_input(input, player, map, stdscr)
	local input_cases = {
		['j'] = function() 
				player:move(0, 1, map)
			end,
		['k'] = function() 
				player:move(0, -1, map)
			end,
		['h'] = function() 
				player:move(-1, 0, map)
			end,
		['l'] = function() 
				player:move(1, 0, map)
			end,
		['y'] = function() 
				player:move(-1, -1, map)
			end,
		['u'] = function() 
				player:move(1, -1, map)
			end,
		['b'] = function() 
				player:move(-1, 1, map)
			end,
		['n'] = function() 
				player:move(1, 1, map)
			end,
		['default'] = function()
				print(input)
			end
		}

	local case = input_cases['default']

	if (input == nil) then
		return position
	else
		case = input_cases[input]
	end
	
	if (case) then
		case()
	end

	return position
end

local function init () 
	getch.set_raw_mode(io.stdin)

	local stdscr = curses.initscr()

	curses.cbreak()
	curses.echo(false)
	curses.curs_set(0)
	curses.nl(false)
	
	stdscr:clear()
	return stdscr
end	

local function game_loop (stdscr)
	local input = 0
	local map = create_map()
	local player = create_player(get_player_spawn(map))
	local characters = {}
	while (input ~= 'q')
	do
		handle_input(input, player, map, stdscr)
		draw_all(stdscr, map, player, characters)
		stdscr:refresh()
		input = string.char(getch.get_char(io.stdin))
	end
end	

local function exit_game()
	curses.endwin()
end

local function main ()
	local stdscr = init()
	
	game_loop(stdscr)

	exit_game()	
end

main()
