-- Adapted from https://github.com/ClobberXD/mid_measure

-- 'Enum' to keep track of current operation
local none_set, pos1_set, pos2_set = 0, 1, 2

local distance
local instances = {}
local range = 30
local timer_count = 0

local priv_table = { shout = true }
-- use forestry_tools.check_perm instead of check_perm

-- Give the measuring tape to any player who joins with adequate privileges or take it away if they do not have them
minetest.register_on_joinplayer(function(player)
	instances[player:get_player_name()] = {
		pos1 = {x=0, y=0, z=0},
		pos2 = {x=0, y=0, z=0},
		node1 = {name = ""},
		node2 = {name = ""},
		tape_nodes = {},
		orig_nodes = {},
		mark_status = none_set
	}
end)


-- pos1 (start position) marker node
minetest.register_node("forestry_tools:measure_pos1", {
	description = "Measure Pos1",
	tiles = {"measure_pos1.png"},
	is_ground_content = false,
	light_source = minetest.LIGHT_MAX,
	groups = {not_in_creative_inventory, immortal}	
})

-- pos2 (end position) marker node
minetest.register_node("forestry_tools:measure_pos2", {
	description = "Measure Pos2",
	tiles = {"measure_pos2.png"},
	is_ground_content = false,
	light_source = minetest.LIGHT_MAX,
	groups = {not_in_creative_inventory, immortal}
})

-- Marks pos1 and starts auto-reset counter
function mark_pos1(player, pos)
	instances[player].pos1 = pos
	instances[player].node1 = minetest.get_node(pos)
    -- TODO: don't want it to swap just want it to place on top
	minetest.swap_node(pos, {name = "forestry_tools:measure_pos1"})
	tell_player(player, "Start position marked")
	instances[player].mark_status = pos1_set

	-- Reads auto-reset duration from conf, defaults to 20 seconds if setting non-existent
	local auto_reset = tonumber(minetest.settings:get("forestry_tools.auto_reset"))
	if not auto_reset then
		auto_reset = 20
		minetest.settings:set("forestry_tools.auto_reset", auto_reset)
	end
			
	-- Auto-reset is disabled if auto_reset == 0
	if auto_reset ~= 0 then
		timer_count = timer_count + 1
		minetest.after(auto_reset, reset_check, player)
	end
end


-- Hud displaying distance between player and pos1
local hud = mhud.init()
local function create_hud(player, pos)
	hud:add(player, "measuring_tape:current_distance", {
		hud_elem_type = "waypoint",
		name = "Distance: ",
		text = "m",
		world_pos = instances[player].pos1,
		color = 0x000000
	})
end


-- Helper for laying tape between pos1 and pos2
local function changePos(pos, plane, change, player)
	local newPos
	if plane == "y" then
		if pos.y > instances[player].pos1.y then change = change * -1 end
		newPos = {x = pos.x, y = pos.y + change, z = pos.z}
	elseif plane == "x" then
		if pos.x > instances[player].pos1.x then change = change * -1 end
		newPos = {x = pos.x + change, y = pos.y, z = pos.z}
	else
		if pos.z > instances[player].pos1.z then change = change * -1 end
		newPos = {x = pos.x, y = pos.y, z = pos.z + change}
	end

	return newPos
end

-- Marks pos2 and performs calculations
function mark_pos2(player, pos)
	instances[player].pos2 = pos
	instances[player].node2 = minetest.get_node(pos)
	minetest.swap_node(pos, {name = "forestry_tools:measure_pos2"})
	tell_player(player, "End position marked")
	instances[player].mark_status = pos2_set
	hud:remove_all()
	
	-- Calculate the distance and display output
	distance = math.floor(vector.distance(instances[player].pos1, instances[player].pos2) + 0.5)

	if distance > range then
		tell_player(player, "Out of range! Maximum distance is 30m")
		return
	end
	
	local newPos
	local direction_change

	if pos.x == instances[player].pos1.x then
		if pos.y == instances[player].pos1.y then
			direction_change = "z"
		elseif pos.z == instances[player].pos1.z then
			direction_change = "y"
		else
			direction_change = "yz"
		end
	elseif pos.y == instances[player].pos1.y then
		if pos.z == instances[player].pos1.z then
			direction_change = "x"
		else
			direction_change = "xz"
		end
	else
		direction_change = "xy"
	end

	if #direction_change == 1 then
		for i = 1, distance - 1 do
			if direction_change == "x" then
				newPos = changePos(pos, "x", i, player)
			elseif direction_change == "y" then
				newPos = changePos(pos, "y", i, player)
			else
				newPos = changePos(pos, "z", i, player)
			end

			instances[player].tape_nodes[i] = newPos
			instances[player].orig_nodes[i] = minetest.get_node(newPos)
			minetest.swap_node(newPos, {name = "forestry_tools:measure_pos1"})
		end
	else 
		for i = 1, distance - 2 do
			if direction_change == "xy" then
				newPos = changePos(pos, "x", i, player)
				newPos = changePos(newPos, "y", i, player)
			elseif direction_change == "yz" then
				newPos = changePos(pos, "y", i, player)
				newPos = changePos(newPos, "z", i, player)
			else
				newPos = changePos(pos, "x", i, player)
				newPos = changePos(newPos, "z", i, player)
			end

			instances[player].tape_nodes[i] = newPos
			instances[player].orig_nodes[i] = minetest.get_node(newPos)
			minetest.swap_node(newPos, {name = "forestry_tools:measure_pos1"})
		end
	end

	-- for i = 1, distance - 1 do
	-- 	if pos.x == instances[player].pos1.x then
	-- 		if pos.y == instances[player].pos1.y then
	-- 			newPos = changePos(pos, "z", i, player)
	-- 		elseif pos.z == instances[player].pos1.z then
	-- 			newPos = changePos(pos, "y", i, player)
	-- 		else
	-- 			newPos = changePos(pos, "y", i, player)
	-- 			newPos = changePos(newPos, "z", i, player)
	-- 		end
	-- 	elseif pos.y == instances[player].pos1.y then
	-- 		if pos.z == instances[player].pos1.z then
	-- 			newPos = changePos(pos, "x", i, player)
	-- 		else
	-- 			newPos = changePos(pos, "x", i, player)
	-- 			newPos = changePos(newPos, "z", i, player)
	-- 		end
	-- 	else 
	-- 		newPos = changePos(pos, "x", i, player)
	-- 		newPos = changePos(newPos, "y", i, player)
	-- 	end


	-- 	instances[player].tape_nodes[i] = newPos
	-- 	instances[player].orig_nodes[i] = minetest.get_node(newPos)
	-- 	minetest.swap_node(newPos, {name = "forestry_tools:measure_pos1"})
	-- end

	tell_player(player, "Distance: " .. minetest.colorize("#FFFF00", distance) .. "m")
end

-- Prevents premature auto-reset
function reset_check(player) 
	if timer_count > 0 then
		timer_count = timer_count - 1
	end

	if timer_count == 0 then
		reset(player)
	end
end

-- Resets tape; replaces marker nodes with the old nodes
function reset(player)
	if instances[player].mark_status == none_set then
		return
	end
	
	if instances[player].mark_status == pos1_set then
		minetest.swap_node(instances[player].pos1, instances[player].node1)
	elseif instances[player].mark_status == pos2_set then
		minetest.swap_node(instances[player].pos1, instances[player].node1)
		minetest.swap_node(instances[player].pos2, instances[player].node2)

		if instances[player].tape_nodes[1] ~= nil and instances[player].orig_nodes[1] ~= nil then
			for i = 1, distance - 1 do
				if instances[player].tape_nodes[i] then
					minetest.swap_node(instances[player].tape_nodes[i], instances[player].orig_nodes[i])
				end
			end
		end
	end
		
	instances[player].mark_status = none_set
	
	if hud then
		hud:remove_all()
	end
	
	if minetest.get_player_by_name(player) then
		tell_player(player, "Tape has been reset")
	end
end

-- Convenience method which just calls minetest.chat_send_player() after prefixing msg with "Measuring Tape - "
function tell_player(player_name, msg)
	minetest.chat_send_player(player_name, "Measuring Tape - " .. msg)	
end

minetest.register_tool("forestry_tools:measuringTape" , {
	description = "Measuring Tape",
	inventory_image = "measuring_tape.png",
    stack_max = 1,
	liquids_pointable = true,
	_mc_tool_privs = priv_table,

	-- On left-click
    on_use = function(itemstack, placer, pointed_thing)
	
		placer = placer:get_player_name()
		if pointed_thing.type == "node" then
		
			local pointed_node = minetest.get_node(pointed_thing.under).name
			if pointed_node == "forestry_tools:measure_pos1" or pointed_node == "forestry_tools:measure_pos2" then
				reset(placer)
				return
			end
					
			-- If pos1 not marked, mark pos1
			if instances[placer].mark_status == none_set then
				mark_pos1(placer, pointed_thing.under)
				create_hud(placer, pointed_thing.under)
			
			-- If pos1 marked, mark pos2 perform calculations, and trigger auto-reset
			elseif instances[placer].mark_status == pos1_set then
				mark_pos2(placer, pointed_thing.under)
			end
		end
		
		return itemstack
	end,

	-- Destroy the item on_drop to keep things tidy
	on_drop = function (itemstack, dropper, pos)
	end,
})

minetest.register_alias("measuringTape", "forestry_tools:measuringTape")
measuringTape = minetest.registered_aliases[measuringTape] or measuringTape





