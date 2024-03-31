dofile "pos.lua"

function load_item_enums()
	item_type = {
		potion = 1,
		scroll = 2,
		weapon = 3,
		armor = 4,
		gold = 5
	}

	armor_type = {
		helmet = 1,
		chest = 2,
		boots = 3
	}

	potion_enum = {
		heal = heal_player
	}
end

function heal_player(game_state)
	game_state.player.hp = game_state.player.hp + 4
end

function item(position, item_type, second_type)
	local item = {}
	item.pos = position
	item.name = "name"
	item.item_type = item_type
	item.second_type = second_type
	return item
end

function spawn_items(game_state)
	for i=1,8 do
		position = nil
		prev_tile = nil
		repeat
			local room = game_state.map.rooms[math.random(1, #game_state.map.rooms)]
			position = pos(math.random(room.top_left.x + 1, room.bot_right.x - 1),
				math.random(room.top_left.y + 1, room.bot_right.y - 1))
			prev_tile = game_state.output_tiles[position.y][position.x]
		until prev_tile.walkable and not prev_tile.item and not prev_tile.occupant
		table.insert(game_state.items, item(position, item_type.potion, potion_enum.heal))
	end
end

function draw_items(game_state)
	for i, v in ipairs(game_state.items) do
		local prev_tile = game_state.output_tiles[v.pos.y][v.pos.x]
		if prev_tile.occupant == nil then
			local tile = tile(v.pos, 'i')
			tile.walkable = true
			tile.item = i
			game_state.output_tiles[v.pos.y][v.pos.x] = tile
		end
	end
end

function open_inv(game_state)
	game_state.inv_open = not game_state.inv_open
end
