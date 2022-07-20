local closed_HUD_showing, open_HUD_showing = false, false
local mag_declination, azimuth, curr_azimuth = 0, 0, 0
local curr_needle, curr_bezel = "needle_0.png", "bezel_0.png" 

---------------------------
--- FORMSPEC MANAGEMENT ---
---------------------------

local adjustments_menu = {
	"formspec_version[5]",
	"size[13,7]",
	"textarea[5,0.2;3,0.5;;;Compass Settings]",
	"textarea[0.5,1.3;5,0.5;declination;Set Magnetic Declination;]",
	"textarea[0.5,2.5;5,0.5;azimuth;Set Azimuth;]",
	"button_exit[0.1,0.1;0.5,0.5;exit;X]",
	"button[8,5.8;3,0.8;save;Adjust Compass]",
	"button[0.5,3.3;3.5,0.8;getAzimuth;Get Current Azimuth]",
	"box[0.5,4.2;5,0.5;#808080]",
	"textarea[0.5,4.2;5,0.5;;;]",
	"image[4.5,-2;10,10;compass_mirror.png]",
	"image[4.5,-2;10,10;needle_0.png]",
	"image[4.5,-2;10,10;bezel_0.png]"
}

-- gives the appearance that the formspec remembers the previously set value for the given field
local function remember_field(formTableName, index, preText, newText, postText)
	local textarea = formTableName[index]
	textarea = preText .. newText .. postText
	formTableName[index] = textarea
end

local function show_adjustments_menu(player) 
	remember_field(adjustments_menu, 4, "textarea[0.5,1.3;5,0.5;declination;Set Magnetic Declination;", mag_declination, "]")
	remember_field(adjustments_menu, 5, "textarea[0.5,2.5;5,0.5;azimuth;Set Azimuth;", azimuth, "]")
	minetest.show_formspec(player:get_player_name(), "compass:adjustments_menu", table.concat(adjustments_menu, ""))
end

local function update_formspec_needle(player)
	local preText = "image[4.5,-2;10,10;"

	if string.len(curr_needle) > 12 then 
		if string.sub(curr_needle, 13, 27) == "^[transformR90" or string.sub(curr_needle, 15, 29) == "^[transformR90" then
			preText = "image[3.75,-1.26;10,10;"
		elseif string.sub(curr_needle, 13, 27) == "^[transformR180" or string.sub(curr_needle, 15, 29) == "^[transformR180" then
			preText = "image[4.5,-0.55;10,10;"
		elseif string.sub(curr_needle, 13, 27) == "^[transformR270" or string.sub(curr_needle, 15, 29) == "^[transformR270" then
			preText = "image[5.26,-1.26;10,10;"
		end
	end

	adjustments_menu[12] = preText .. curr_needle .. "]"
	show_adjustments_menu(player)
end

local function update_formspec_bezel(player)
	local preText = "image[4.5,-2;10,10;"

	if string.len(curr_bezel) > 11 then 
		if string.sub(curr_bezel, 12, 25) == "^[transformR90" or string.sub(curr_bezel, 14, 27) == "^[transformR90" then
			preText = "image[3.75,-1.26;10,10;"
		elseif string.sub(curr_bezel, 12, 26) == "^[transformR180" or string.sub(curr_bezel, 14, 28) == "^[transformR180" then
			preText = "image[4.5,-0.55;10,10;"
		elseif string.sub(curr_bezel, 12, 26) == "^[transformR270" or string.sub(curr_bezel, 14, 28) == "^[transformR270" then
			preText = "image[5.26,-1.26;10,10;"
		end
	end

	adjustments_menu[13] = preText .. curr_bezel .. "]"
	show_adjustments_menu(player)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local pname = player:get_player_name()

	if formname == "compass:adjustments_menu" then

		if fields.exit then
			adjustments_menu[10] = "textarea[0.5,4.2;5,0.5;;;]"
		end

		if fields.getAzimuth then
			adjustments_menu[10] = "textarea[0.5,4.2;5,0.5;;;" .. math.floor(curr_azimuth) .. "]"
			show_adjustments_menu(player)
		end

		if fields.save then
			local pmeta = player:get_meta()

			if fields.declination ~= "" and tonumber(fields.declination) ~= mag_declination then
				local only_nums = tonumber(fields.declination) ~= nil

				if only_nums then
					local declination_entered = tonumber(fields.declination)
					if math.abs(declination_entered) > 90 or math.abs(declination_entered) < -90 then
						minetest.chat_send_player(pname, minetest.colorize("#ff0000", "Compass - magnetic declination must be a number between -90 and 90"))
					else
						mag_declination = declination_entered
						pmeta:set_int("declination", mag_declination)

						minetest.chat_send_player(pname, minetest.colorize("#00ff00", "Compass - magnetic declination set to " .. fields.declination .. "°"))

						minetest.after(0.1, update_formspec_needle, player)
						minetest.after(0.1, update_formspec_bezel, player)
					end
				else 
					minetest.chat_send_player(pname, minetest.colorize("#ff0000", "Compass - magnetic declination must be a number between -90 and 90"))
				end
			end

			if fields.azimuth ~= "" and tonumber(fields.azimuth) ~= azimuth then
				local only_nums = tonumber(fields.azimuth) ~= nil

				if only_nums then
					local azimuth_entered = tonumber(fields.azimuth)
					if azimuth_entered > 360 or azimuth_entered < 0 then
						minetest.chat_send_player(pname, minetest.colorize("#ff0000", "Compass - azimuth must be a number between 0 and 360"))
					else
						azimuth = azimuth_entered
						pmeta:set_int("azimuth", azimuth)

						minetest.chat_send_player(pname, minetest.colorize("#00ff00", "Compass - azimuth set to " .. fields.azimuth .. "°"))

						minetest.after(0.1, update_formspec_bezel, player)
					end
				else 
					minetest.chat_send_player(pname, minetest.colorize("#ff0000", "Compass - azimuth must be a number between 0 and 360"))
				end
			end

			if tonumber(fields.declination) ~= 0 and string.sub(adjustments_menu[11], 25, 26) ~= "]" then
				adjustments_menu[10] = "textarea[0.5,4.2;5,0.5;;;]"
				show_adjustments_menu(player)
			end
		end

	end
end)

--------------------------------------------
--- HUD MANAGEMENT AND TOOL REGISTRATION ---
--------------------------------------------

local closedHud = mhud.init()
local function show_closed_hud(player)
	closedHud:add(player, "closed", {
		hud_elem_type = "image",
		text = "compass_closed.png",
		position = {x = 0.5, y = 0.45}, 
		scale = {x = 5, y = 5},
		offset = {x = -4, y = -4}
	})

	closed_HUD_showing = true
end

local needleHud = mhud.init()
local function show_needle_hud(player)
	needleHud:add(player, "needle", {
		hud_elem_type = "image",
		text = "needle_0.png",
		position = {x = 0.5, y = 0.45}, 
		scale = {x = 5, y = 5},
		offset = {x = -4, y = -4},
		alignment = {x = "centre", y = "centre"}
	})

	open_HUD_showing = true
end

local bezelHud = mhud.init()
local function show_bezel_hud(player)
	bezelHud:add(player, "bezel", {
		hud_elem_type = "image",
		text = "bezel_0.png",
		position = {x = 0.5, y = 0.45}, 
		scale = {x = 5, y = 5},
		offset = {x = -4, y = -4},
		alignment = {x = "centre", y = "centre"}
	})
end

local mirrorHud = mhud.init()
local function show_mirror_hud(player)
	mirrorHud:add(player, "mirror", {
		hud_elem_type = "image",
		text = "compass_mirror.png",
		position = {x = 0.5, y = 0.45}, 
		scale = {x = 5, y = 5},
		offset = {x = -4, y = -4}
	})
end

minetest.register_tool("forestry_tools:compass" , {
	description = "Compass",
	inventory_image = "compass_icon.png",
    stack_max = 1,
	liquids_pointable = true,
	_mc_tool_privs = forestry_tools.priv_table,

	-- On left-click
    on_use = function(itemstack, player, pointed_thing)
		local pmeta = player:get_meta()
		mag_declination = pmeta:get_int("declination")
		azimuth = pmeta:get_int("azimuth")

		if not closed_HUD_showing and not open_HUD_showing then
			show_closed_hud(player)
		elseif closed_HUD_showing then
			closedHud:remove_all(player)
			closed_HUD_showing = false

			show_mirror_hud(player)
			show_needle_hud(player)
			show_bezel_hud(player)
		else
			needleHud:remove_all()
			bezelHud:remove_all()
			mirrorHud:remove_all()
			open_HUD_showing = false
		end
	end,

	-- On right-click
	on_place = function(itemstack, placer, pointed_thing)
		if open_HUD_showing then 
			update_formspec_needle(placer)
			update_formspec_bezel(placer)
			show_adjustments_menu(placer) 
		end
	end,

	on_secondary_use = function(itemstack, player, pointed_thing)
		if open_HUD_showing then 
			update_formspec_needle(player)
			update_formspec_bezel(player)
			show_adjustments_menu(player) 
		end
	end,

	-- Destroy the item on_drop 
	on_drop = function (itemstack, dropper, pos)
	end,
})

minetest.register_globalstep(function(dtime)
	local players  = minetest.get_connected_players()
	for i,player in ipairs(players) do

		if closed_HUD_showing then
			if player:get_wielded_item():get_name() ~= "forestry_tools:compass" then
				closedHud:remove_all()
				closed_HUD_showing = false
			end
		end

		if open_HUD_showing then
			-- Remove HUD when player is no longer wielding the compass
			if player:get_wielded_item():get_name() ~= "forestry_tools:compass" then
				needleHud:remove_all()
				bezelHud:remove_all()
				mirrorHud:remove_all()
				open_HUD_showing = false
			else
				local dir = player:get_look_horizontal()
				local angle_relative = math.deg(dir)

				-- Set magnetic declination
				if mag_declination > 0 and (360 - angle_relative) <= math.abs(mag_declination) then
					angle_relative = mag_declination - (360 - angle_relative)
				elseif mag_declination < 0 and angle_relative <= math.abs(mag_declination) then
					angle_relative = 360 - (math.abs(mag_declination) - angle_relative)
				else 
					angle_relative = math.deg(dir) + mag_declination
				end

				-- Update current azimuth to direction player is facing 
				curr_azimuth = 360 - angle_relative

				-- Needle rotation
				local needle_text = rotate_texture(player, needleHud, "needle", angle_relative)
				curr_needle = needle_text
				needleHud:change(player, "needle", {
					text = needle_text
				})

				-- Rotate bezel based on azimuth and declination set
				local shed_angle
				if mag_declination > 0 and azimuth < mag_declination then
					shed_angle = mag_declination - azimuth
				elseif mag_declination < 0 and (360 - azimuth) < math.abs(mag_declination) then
					shed_angle = mag_declination + azimuth 
				else
					shed_angle = mag_declination + (360 - azimuth)
				end

				local bezel_text = rotate_texture(player, bezelHud, "bezel", shed_angle)
				curr_bezel = bezel_text
				bezelHud:change(player, "bezel", {
					text = bezel_text
				})
			end
		end
	end
end)

-- Helper for rotating HUD images. The needle/bezel only show an angle change in intervals of 10, with the exception of 45°, 135°, 225°, 315°
-- e.g. the needle will be in the same position from 0°-9°, then rotate to a new position for 10°-19°, etc. (same system applies to the bezel)
-- Returns the name of the corresponding texture
local prev_bez_rotation = 0

function rotate_texture(player, hud, hudName, referenceAngle) 
	local adjustment, transformation, imgIndex
	local x, y

	if referenceAngle < 90 or referenceAngle == 360 then
		adjustment = 0
		transformation = 0
		x, y = -4, -4
	elseif referenceAngle < 180 then
		adjustment = 90
		transformation = 270
		x, y = 90, 91
	elseif referenceAngle < 270 then
		adjustment = 180
		transformation = 180
		x, y = -5, 185
	elseif referenceAngle < 360 then
		adjustment = 270
		transformation = 90
		x, y = -99, 91
	end

	hud:change(player, hudName, {
		offset = {x = x, y = y}
	})

	if math.floor(referenceAngle % 45) <= 4 and not (math.floor(referenceAngle % 90) <= 9) then
		imgIndex = 4.5
	elseif referenceAngle == 360 then
		imgIndex = 0
	else
		imgIndex = math.floor((referenceAngle - adjustment)/10)
	end

	return hudName .. "_" .. imgIndex .. ".png" .. "^[transformR" .. transformation
end
