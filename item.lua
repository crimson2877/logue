dofile "pos.lua"

function load_item_enums()
	item_type_enum = {
		potion = 1,
		scroll = 2,
		weapon = 3,
		armor = 4,
		gold = 5
	}

	armor_type_enum = {
		helmet = 1,
		chest = 2,
		boots = 3
	}

	potion_enum = {
		heal = 1
	}
end

function gen_item_details(item_type, second_type)
	local name, func
	if item_type == item_type_enum.potion then
		if second_type == potion_enum.heal then
			name = "Heal Potion"
			func = game_state.player.heal
		end
	elseif item_type == item_type_enum.gold then
		name = "Gold"
		func = math.random(50)
	end
	return name, func
end

function item(position, item_type, second_type)
	local item = {}
	item.pos = position
	item.item_type = item_type
	item.second_type = second_type
	item.name, item.func = gen_item_details(item_type, second_type)
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
		local item_type = math.random(0, 1) * 4 + 1
		if item_type == item_type_enum.potion then
			local second_type = potion_enum.heal
		else
			local second_type = nil
		end

		table.insert(game_state.items, item(position, item_type, potion_enum.heal))
	end
end

function draw_items(game_state)
	for i,v in pairs(game_state.items) do
		local prev_tile = game_state.output_tiles[v.pos.y][v.pos.x]
		if prev_tile.occupant == nil then
			local tile = tile(v.pos, 'i')
			tile.walkable = true
			tile.item = i
			if v.item_type == item_type_enum.gold then
				tile.char = '$'
				tile.color = {.82, .82, 0, 1}
			elseif v.item_type == item_type_enum.potion then
				tile.char = '!'
				tile.color = {.3, .7, 1, 1}
				tile.seen = prev_tile.seen
			end
			tile.seen = prev_tile.seen
			game_state.output_tiles[v.pos.y][v.pos.x] = tile
		end
	end
end

function open_inv(game_state)
	game_state.inv_open = not game_state.inv_open
end
