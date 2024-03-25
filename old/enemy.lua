dofile("character.lua")

function create_goblin(position)
	local goblin = init_character(
			position,
			2,
			1,
			'g')
	return goblin
end
