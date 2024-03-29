function move_by_key(player, entities, map, key, delta_pos, last_key, last_key_delay, last_key_delay_count, output_tiles)
	local update_all = false
	if last_key ~= key or (last_key == key and last_key_delay_count >= last_key_delay) then
		update_all = true
		logline = player:move(delta_pos, entities, output_tiles, map)
		if last_key ~= key then
			last_key_delay_count = 0
		end
		last_key = key
	end
	return last_key, last_key_delay_count, logline, update_all
end
