local S = forestry_tools.S
local HUD_showing = false
local curr_pitch = 0
local bg_angle

----------------------------
--- HUDS FOR DEGREE SIDE ---
----------------------------

local degreePlus0Hud = mhud.init()
local function show_degree_plus_0_hud(player)
	degreePlus0Hud:add(player, "degreePlus0", {
		hud_elem_type = "text",
		text = "",
		alignment = {x = "left", y = "centre"},
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = -40, y = -4}
	})
end

local degreePlus10Hud = mhud.init()
local function show_degree_plus_10_hud(player)
	degreePlus10Hud:add(player, "degreePlus10", {
		hud_elem_type = "text",
		text = "",
		alignment = {x = "left", y = "centre"},
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = -40, y = -70}
	})
end

local degreePlus20Hud = mhud.init()
local function show_degree_plus_20_hud(player)
	degreePlus20Hud:add(player, "degreePlus20", {
		hud_elem_type = "text",
		text = "",
		alignment = {x = "left", y = "centre"},
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = -40, y = -135}
	})
end

local degreeMinus10Hud = mhud.init()
local function show_degree_minus_10_hud(player)
	degreeMinus10Hud:add(player, "degreeMinus10", {
		hud_elem_type = "text",
		text = "",
		alignment = {x = "left", y = "centre"},
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = -40, y = 62}
	})
end

local degreeMinus20Hud = mhud.init()
local function show_degree_minus_20_hud(player)
	degreeMinus20Hud:add(player, "degreeMinus20", {
		hud_elem_type = "text",
		text = "",
		alignment = {x = "left", y = "centre"},
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = -40, y = 125}
	})
end

-----------------------------
--- HUDS FOR PERCENT SIDE ---
-----------------------------

local percentPlus0Hud = mhud.init()
local function show_percent_plus_0_hud(player)
	percentPlus0Hud:add(player, "percentPlus0", {
		hud_elem_type = "text",
		text = "test0",
		alignment = {x = "left", y = "centre"},
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = 73, y = -4}
	})
end

local percentPlus10Hud = mhud.init()
local function show_percent_plus_10_hud(player)
	percentPlus10Hud:add(player, "percentPlus10", {
		hud_elem_type = "text",
		text = "test10",
		alignment = {x = "left", y = "centre"},
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = 80, y = -43}
	})
end

local percentPlus20Hud = mhud.init()
local function show_percent_plus_20_hud(player)
	percentPlus20Hud:add(player, "percentPlus20", {
		hud_elem_type = "text",
		text = "test20",
		alignment = {x = "left", y = "centre"},
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = 80, y = -83}
	})
end

local percentMinus10Hud = mhud.init()
local function show_percent_minus_10_hud(player)
	percentMinus10Hud:add(player, "percentMinus10", {
		hud_elem_type = "text",
		text = "test-10",
		alignment = {x = "left", y = "centre"},
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = 85, y = 37}
	})
end

local percentMinus20Hud = mhud.init()
local function show_percent_minus_20_hud(player)
	percentMinus20Hud:add(player, "percentMinus20", {
		hud_elem_type = "text",
		text = "test-20",
		alignment = {x = "left", y = "centre"},
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = 85, y = 75}
	})
end


----------------------
--- HUD MANAGEMENT ---
----------------------

local bgHud = mhud.init()
local function show_bg_hud(player)
	bgHud:add(player, "background", {
		hud_elem_type = "image",
		text = "clinometer_0.png",
		position = {x = 0.7, y = 0.5}, 
		scale = {x = 6.5, y = 6.5},
		offset = {x = -4, y = -4}
	})

	HUD_showing = true
end

local function show_huds(player)
	show_bg_hud(player)
	show_degree_plus_0_hud(player)
	show_degree_plus_10_hud(player)
	show_degree_plus_20_hud(player)
	show_degree_minus_10_hud(player)
	show_degree_minus_20_hud(player)
	show_percent_plus_0_hud(player)
	show_percent_plus_10_hud(player)
	show_percent_plus_20_hud(player)
	show_percent_minus_10_hud(player)
	show_percent_minus_20_hud(player)
	HUD_showing = true
end

local function hide_huds(player)
	bgHud:remove_all()
	degreePlus0Hud:remove_all()
	degreePlus10Hud:remove_all()
	degreePlus20Hud:remove_all()
	degreeMinus10Hud:remove_all()
	degreeMinus20Hud:remove_all()
	percentPlus0Hud:remove_all()
	percentPlus10Hud:remove_all()
	percentPlus20Hud:remove_all()
	percentMinus10Hud:remove_all()
	percentMinus20Hud:remove_all()
	HUD_showing = false
end

minetest.register_tool("forestry_tools:clinometer" , {
	description = "Clinometer",
	inventory_image = "clinometer_icon.png",
    stack_max = 1,
	liquids_pointable = true,
	_mc_tool_privs = forestry_tools.priv_table,

	-- On left-click
    on_use = function(itemstack, player, pointed_thing)
		if HUD_showing then
			hide_huds(player)
		else
			show_huds(player)
		end
	end,

	-- Destroy the item on_drop 
	on_drop = function (itemstack, dropper, pos)
	end,
})

local function update_hud(player, hud, hudname, text) 
	local newtext
	if hudname == "background" then
		newtext = "clinometer_" .. text .. ".png"
	else
		newtext = text
	end

	hud:change(player, hudname, {
		text = newtext
	})
end

local function update_degrees(player)
	if curr_pitch >= 80 and curr_pitch < 89 then
		update_hud(player, degreePlus20Hud, "degreePlus20", "")  
	elseif curr_pitch >= 89 then
		update_hud(player, degreePlus10Hud, "degreePlus10", "") 
	elseif curr_pitch <= -80 and curr_pitch > -89 then
		update_hud(player, degreeMinus20Hud, "degreeMinus20", "") 
	elseif curr_pitch <= -89 then
		update_hud(player, degreeMinus10Hud, "degreeMinus10", "") 
	else 
		update_hud(player, degreePlus10Hud, "degreePlus10", tostring(curr_pitch + 10))
		update_hud(player, degreePlus20Hud, "degreePlus20", tostring(curr_pitch + 20))
		update_hud(player, degreeMinus10Hud, "degreeMinus10", tostring(curr_pitch - 10))
		update_hud(player, degreeMinus20Hud, "degreeMinus20", tostring(curr_pitch - 20)) 
	end

	update_hud(player, bgHud, "background", bg_angle) 
	update_hud(player, degreePlus0Hud, "degreePlus0", tostring(curr_pitch)) 
end


minetest.register_globalstep(function(dtime)
	local players  = minetest.get_connected_players()
	for i,player in ipairs(players) do

		if HUD_showing then
			local pitch_rad = player:get_look_vertical()
			local pitch = -1 * math.deg(pitch_rad)
			curr_pitch = math.floor(pitch)

			if curr_pitch >= 70 then 
				if curr_pitch < 80 then
					bg_angle = "70"
				elseif curr_pitch >= 80 and curr_pitch < 89 then
					bg_angle = "80"
				elseif curr_pitch >= 89 then
					bg_angle = "90"
				end
			elseif curr_pitch <= -70 then
				if curr_pitch > -80 then
					bg_angle = "70.1"
				elseif curr_pitch <= -80 and curr_pitch > -89 then
					bg_angle = "80.1"
				elseif curr_pitch <= -89 then
					bg_angle = "90.1"
				end
			else 
				bg_angle = "0"
			end

			update_degrees(player) 

			local percent
			if pitch == 90 or pitch == -90 then
				percent = 0
			else
				percent = math.floor(-100 * math.tan(pitch_rad))
			end

			update_hud(player, percentPlus0Hud, "percentPlus0", tostring(percent)) 
			update_hud(player, percentPlus10Hud, "percentPlus10", tostring(percent + 10))
			update_hud(player, percentPlus20Hud, "percentPlus20", tostring(percent + 20))
			update_hud(player, percentMinus10Hud, "percentMinus10", tostring(percent - 10))
			update_hud(player, percentMinus20Hud, "percentMinus20", tostring(percent - 20)) 
		end
	end
end)



-- -- IN-PROGRESS: show yaw (horizontal angle) and pitch (vertical viewing angle) in degrees.

-- -- <!> This is important, since calls to S() are made in this file - without this, the game will crash
-- local S = forestry_tools.S
-- local HUD_showing = false; 



-- minetest.register_tool("forestry_tools:clinometer", {
-- 	description = S("Yaw (horizontal) and Sextant (vertical)"),
-- 	_tt_help = S("Shows your pitch"),
-- 	_doc_items_longdesc = S("It shows your pitch (vertical viewing angle) in degrees. and your sextant (horizontal viewing angle) in degrees"),
-- 	_doc_items_usagehelp = use,
-- 	wield_image = "clinometer.png",
-- 	inventory_image = "clinometer.png",
-- 	groups = { disable_repair = 1 },
-- 	_mc_tool_privs = forestry_tools.priv_table,

			
-- 		-- On left-click
--     on_use = function(itemstack, player, pointed_thing)
-- 		if HUD_showing then
-- 			clinHud:remove_all()
-- 			HUD_showing = false
-- 		else
-- 			show_clin_hud(player)
-- 		end
-- 	end,
		
--     	-- Destroy the item on_drop to keep things tidy
-- 	on_drop = function (itemstack, dropper, pos)
-- 	end
-- })



-- minetest.register_alias("clinometer", "forestry_tools:clinometer")
-- clinometer = minetest.registered_aliases[clinometer] or clinometer






	
-- -- minetest.register_on_newplayer(clin_hud.init_hud)
-- -- minetest.register_on_joinplayer(clin_hud.init_hud)

-- -- minetest.register_on_leaveplayer(function(player)
-- -- 	clin_hud.playerhuds[player:get_player_name()] = nil
-- -- end)


-- local clinHud = mhud.init()
-- local function show_clin_hud(player)
-- 	clinHud:add(player, "clinometer", {
-- 		hud_elem_type = "text",
-- 		text = "",
-- 		number =  "0xFF0000",
-- 		position={x = 0.5, y = 0}, 
-- 		scale={x = 10, y = 10},
-- 		offset = {x = 0, y = 15},
-- 		z_index = 0,
			
-- 	})
-- end



-- function update_hud_displays(player)
-- 	local toDegrees = 180/math.pi
-- 	local name = player:get_player_name()
-- 	local clinometer
-- 	local pos = vector.round(player:get_pos())
	
	
-- 	if tool_active(player, "forestry_tools:clinometer") then 
-- 		clinometer = true 
-- 	end 
	
	
	
-- 	-- Minetest goes counter clokwise
-- 	local yaw = 360 - player:get_look_horizontal()*toDegrees
-- 	local pitch = player:get_look_vertical()*toDegrees
	
-- 	if (clinometer) then
-- 		str_angles = S("Yaw: @1°, pitch: @2°", string.format("%.1f", yaw), string.format("%.1f", pitch))
-- 	end
	

-- 	if str_angles ~= "" then 
-- 		player:hud_change(name, "text", strs_angles)
-- 	end
-- end
	
-- 	-- issues w updating HUD 
	  


-- minetest.register_globalstep(function(dtime)
-- 	local players  = minetest.get_connected_players()
-- 	for i,player in ipairs(players) do

-- 		if HUD_showing then
-- 			-- Remove HUD when player is no longer wielding the clinometer
-- 			if player:get_wielded_item():get_name() ~= "forestry_tools:clinometer" then
-- 				clinHud:remove_all()
-- 				HUD_showing = false
-- 			else
				

-- 			-- not sure(?)
-- 			update_hud_displays(player)
    
-- 		end

			
-- 		end
-- 	end
	
-- end)
	
	
-- -- have to account for change of player FOV, direction, update HUD to display

-- -- <!> These two lines currently crash the game - please replace with functions if they are intended to be used
-- --minetest.register_on_newplayer(clinHud)
-- --minetest.register_on_joinplayer(clinHud)



-- -- local clin_hud = {}
-- -- clin_hud.playerhuds = {}
-- -- clin_hud.settings = {}
-- -- clin_hud.settings.hud_pos = { x = 0.5, y = 0 }
-- -- clin_hud.settings.hud_offset = { x = 0, y = 15 }
-- -- clin_hud.settings.hud_alignment = { x = 0, y = 0 }

-- -- local set = tonumber(minetest.settings:get("clin_hud_pos_x"))
-- -- if set then clin_hud.settings.hud_pos.x = set end
-- -- set = tonumber(minetest.settings:get("clin_hud_pos_y"))
-- -- if set then clin_hud.settings.hud_pos.y = set end
-- -- set = tonumber(minetest.settings:get("clin_hud_offset_x"))
-- -- if set then clin_hud.settings.hud_offset.x = set end
-- -- set = tonumber(minetest.settings:get("clin_hud_offset_y"))
-- -- if set then clin_hud.settings.hud_offset.y = set end
-- -- set = minetest.settings:get("clin_hud_alignment")
-- -- if set == "left" then
-- -- 	clin_hud.settings.hud_alignment.x = 1
-- -- elseif set == "center" then
-- -- 	clin_hud.settings.hud_alignment.x = 0
-- -- elseif set == "right" then
-- -- 	clin_hud.settings.hud_alignment.x = -1
-- -- end

-- -- local lines = 4 -- # of HUD Lines


-- -- DIsplay player horizontal and vertical It shows you your pitch (vertical viewing angle) in degrees.



-- -- function init_hud(player)
-- -- 	update_automapper(player)
-- -- 	local name = player:get_player_name()
-- -- 	playerhuds[name] = {}
-- -- 	for i=1, o_lines do
-- -- 			playerhuds[name]["o_line"..i] = player:hud_add({
-- -- 			hud_elem_type = "text",
-- -- 			text = "",
-- -- 			position = clin_hud.settings.hud_pos,
-- -- 			offset = { x = clin_hud.settings.hud_offset.x, y = clin_hud.settings.hud_offset.y + 20*(i-1) },
-- -- 			alignment = clin_hud.settings.hud_alignment,
-- -- 			number = 0xFFFFFF,
-- -- 			scale= { x = 100, y = 20 },
-- -- 			z_index = 0,
-- -- 		})
-- -- 	end
-- -- end


-- -- function clin_hud.update_automapper(player)
-- -- 	if clin_hud.tool_active(player, "forestry_tools:clinometer") or minetest.is_creative_enabled(player:get_player_name()) then
-- -- 		player:hud_set_flags({minimap = true, minimap_radar = true})
	
-- -- 	else
-- -- 		player:hud_set_flags({minimap = false, minimap_radar = false})
-- -- 	end
-- -- end

	




