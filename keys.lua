keys = {
	move = {
		['j'] = pos(0, 1),
                ['k'] = pos(0, -1),
                ['h'] = pos(-1, 0),
                ['l'] = pos(1, 0),
                ['y'] = pos(-1, -1),
                ['u'] = pos(1, -1),
                ['b'] = pos(-1, 1),
                ['n'] = pos(1, 1),
                ['.'] = pos(0,0)
        },
        meta = {
                ['q'] = love.event.quit,
                ['i'] = open_inv
        },
        actions = {
                ['g'] = game_state.player.pick_item_up,
                ['a'] = game_state.player.use_item
        },
	inv = {
		
	}
}

