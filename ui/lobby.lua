-----------------------------
-- STATE VARIABLES
-----------------------------

local _lobby_options_button
local _leave_lobby_button
local _start_game_button
local _gamemode_display
local _lobby_buttons_initialized = false

local _current_lobby_ref = nil
local _current_lobby_ui_ref = nil

-----------------------------
-- UI FUNCTIONS
-----------------------------

local create_lobby_buttons

SPDRN.build_in_lobby_ui = function()
	create_lobby_buttons()
	MPAPI.set_logo_offset(-10, true)
	return {
		n = G.UIT.ROOT,
		config = { align = 'cm', colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = 'cm' },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = 'cm', padding = 0.1, r = 0.1, emboss = 0.1, colour = G.C.L_BLACK, mid = true },
						nodes = {
							_current_lobby_ui_ref.node,
						},
					},
					{
						n = G.UIT.R,
						config = { minh = 0.2 },
					},
					{
						n = G.UIT.R,
						config = { align = 'cm' },
						nodes = {
							{
								n = G.UIT.C,
								config = { align = 'cm', padding = 0.1, r = 0.1, emboss = 0.1, colour = G.C.L_BLACK, mid = true },
								nodes = {
									_gamemode_display.node,
									{
										n = G.UIT.R,
										config = { align = 'cm' },
										nodes = {
											_start_game_button.node,
										},
									},
									{
										n = G.UIT.R,
										config = { align = 'cm' },
										nodes = {
											_lobby_options_button.node,
											_leave_lobby_button.node,
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}
end

create_lobby_buttons = function()
	if not _lobby_buttons_initialized then
		_lobby_options_button = MPAPI.disableable_button({
			id = 'spdrn_lobby_options',
			button = 'spdrn_lobby_options',
			colour = G.C.ORANGE,
			minw = 3.65,
			minh = 1.55,
			label = localize('b_lobby_options_cap'),
			scale = 0.7,
			col = true,
			enabled = true,
		})
		_leave_lobby_button = MPAPI.disableable_button({
			id = 'spdrn_leave_lobby',
			button = 'spdrn_leave_lobby',
			colour = G.C.RED,
			minw = 3.65,
			minh = 1.55,
			label = localize('b_leave_lobby_cap'),
			scale = 0.7,
			col = true,
			enabled = true,
		})
		_start_game_button = MPAPI.disableable_button({
			id = 'spdrn_start_game',
			button = 'spdrn_start_game',
			colour = G.C.BLUE,
			minw = 3.65,
			minh = 1.55,
			label = { 'START GAME' },
			scale = 0.7,
			enabled = function()
				if not _current_lobby_ref or not _current_lobby_ref.is_host then
					return false
				end
				local meta = _current_lobby_ref:get_metadata()
				local gm = meta.gamemode and MPAPI.GameModes[meta.gamemode]
				if not gm then
					return false
				end
				return #_current_lobby_ref:get_players() >= gm:get_min_players('private')
			end,
		})
		_gamemode_display = MPAPI.ui_element(function()
			local key = _current_lobby_ref and _current_lobby_ref:get_metadata().gamemode
			local gm = key and MPAPI.GameModes[key]
			local label = gm and (gm.display_name or gm.key) or 'None'
			return {
				n = G.UIT.R,
				config = { align = 'cm', padding = 0.05 },
				nodes = {
					{ n = G.UIT.T, config = { text = 'Mode: ' .. label, scale = 0.4, colour = G.C.UI.TEXT_LIGHT } },
				},
			}
		end)
	end

	_lobby_buttons_initialized = true
end

-----------------------------
-- LOGIC FUNCTIONS
-----------------------------

SPDRN.setup_lobby_events = function(lobby, lobby_ui)
	_current_lobby_ref = lobby
	_current_lobby_ui_ref = lobby_ui

	lobby:on('player_joined', function(player_id)
		SPDRN.sendDebugMessage('Player joined: ' .. tostring(player_id))
		if _start_game_button then
			_start_game_button:update()
		end
	end)

	lobby:on('player_left', function(player_id)
		SPDRN.sendDebugMessage('Player left: ' .. tostring(player_id))
		if _start_game_button then
			_start_game_button:update()
		end
	end)

	lobby:on('connected', function()
		if _start_game_button then
			_start_game_button:update()
		end
		if _gamemode_display then
			_gamemode_display:update()
		end
	end)

	lobby:on('metadata_changed', function(metadata)
		if _gamemode_display then
			_gamemode_display:update()
		end
	end)

	lobby:on('host_changed', function()
		if _start_game_button then
			_start_game_button:update()
		end
	end)

	lobby:on('error', function(err)
		SPDRN.sendWarnMessage('Lobby error: ' .. tostring(err))
	end)

	lobby:on('disconnected', function()
		SPDRN.sendDebugMessage('Disconnected from lobby')
		_current_lobby_ref = nil
		_current_lobby_ui_ref = nil
		_lobby_buttons_initialized = false
	end)
end

G.FUNCS.spdrn_lobby_options = function()
	local contents = {
		{ n = G.UIT.R, config = { align = 'cm', padding = 0.1 }, nodes = {
			{ n = G.UIT.T, config = { text = 'Lobby Options', scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
		} },
	}

	if _current_lobby_ref and _current_lobby_ref.is_host then
		local current_key = _current_lobby_ref:get_metadata().gamemode
		contents[#contents + 1] = { n = G.UIT.R, config = { align = 'cm', padding = 0.05 }, nodes = {
			{ n = G.UIT.T, config = { text = 'Change Gamemode', scale = 0.4, colour = G.C.UI.TEXT_LIGHT } },
		} }
		contents[#contents + 1] = {
			n = G.UIT.R,
			config = { align = 'cm', padding = 0.05 },
			nodes = {
				UIBox_button({
					button = 'spdrn_change_white_stake_triple',
					label = { 'White Stake Triple' .. (current_key == 'spdrn_white_stake_triple' and ' *' or '') },
					colour = current_key == 'spdrn_white_stake_triple' and G.C.GREEN or G.C.GREY,
					minw = 4,
					minh = 0.6,
					scale = 0.45,
				}),
			},
		}
		contents[#contents + 1] = {
			n = G.UIT.R,
			config = { align = 'cm', padding = 0.05 },
			nodes = {
				UIBox_button({
					button = 'spdrn_change_gold_stake_single',
					label = { 'Gold Stake Single' .. (current_key == 'spdrn_gold_stake_single' and ' *' or '') },
					colour = current_key == 'spdrn_gold_stake_single' and G.C.GREEN or G.C.GREY,
					minw = 4,
					minh = 0.6,
					scale = 0.45,
				}),
			},
		}
	end

	G.FUNCS.overlay_menu({
		definition = create_UIBox_generic_options({ contents = contents }),
	})
end

local function change_gamemode(key)
	if _current_lobby_ref and _current_lobby_ref.is_host then
		local meta = _current_lobby_ref:get_metadata()
		_current_lobby_ref:set_metadata({ gamemode = key, deck = meta.deck or 'Blue Deck' })
	end
	G.FUNCS.exit_overlay_menu()
end

G.FUNCS.spdrn_change_white_stake_triple = function()
	change_gamemode('spdrn_white_stake_triple')
end

G.FUNCS.spdrn_change_gold_stake_single = function()
	change_gamemode('spdrn_gold_stake_single')
end

local function generate_seed()
	local chars = 'ABCDEFGHIJKLMNPQRSTUVWXYZ123456789'
	local seed = ''
	for i = 1, 8 do
		local idx = math.random(1, #chars)
		seed = seed .. chars:sub(idx, idx)
	end
	return seed
end

G.FUNCS.spdrn_start_game = function()
	if not _current_lobby_ref then
		return
	end
	local action = _current_lobby_ref:action(MPAPI.ActionTypes['spdrn_start_game'])
	action:broadcast({ seed = generate_seed() })
end

G.FUNCS.spdrn_leave_lobby = function()
	if _current_lobby_ref then
		_current_lobby_ref:leave()
	end
end
