-- Forward declarations for helper functions
local create_buttons

-----------------------------
-- STATE VARIABLES
-----------------------------

local _find_game_button
local _create_lobby_button
local _join_by_code_button
local _join_from_clipboard_button
local _practice_button
local _buttons_initialized = false

local _connected = function()
	return MPAPI.is_connected() == 'connected'
end

-----------------------------
-- UI FUNCTIONS
-----------------------------

SPDRN.create_main_menu_ui = function()
	create_buttons()

	return {
		n = G.UIT.ROOT,
		config = { align = 'cm', colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = 'bm' },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = 'cm', padding = 0.1, r = 0.1, emboss = 0.1, colour = G.C.L_BLACK, mid = true },
						nodes = {
							_find_game_button.node,
							_practice_button.node,
							{
								n = G.UIT.C,
								config = { align = 'cm', padding = 0.1, r = 0.2, colour = G.C.BLACK },
								nodes = {
									{
										n = G.UIT.C,
										config = { align = 'cm', maxh = 1.4 },
										nodes = {
											{ n = G.UIT.T, config = { text = localize('b_join_lobby_cap'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, vert = true, maxh = 1.4 } },
										},
									},
									{
										n = G.UIT.C,
										config = { align = 'cm', padding = 0.1 },
										nodes = {
											{ n = G.UIT.R, config = { align = 'cm' }, nodes = { _join_by_code_button.node } },
											{ n = G.UIT.R, config = { align = 'cm' }, nodes = { _join_from_clipboard_button.node } },
										},
									},
								},
							},
							_create_lobby_button.node,
						},
					},
				},
			},
		},
	}
end

create_buttons = function()
	if not _buttons_initialized then
		_find_game_button = MPAPI.disableable_button({
			id = 'spdrn_find_game',
			button = 'spdrn_find_game',
			colour = G.C.BLUE,
			minw = 3.65,
			minh = 1.55,
			label = localize('b_find_game_cap'),
			disabled_text = { localize('b_find_game_cap') },
			scale = 0.7,
			col = true,
			enabled = true,
		})
		_create_lobby_button = MPAPI.disableable_button({
			id = 'spdrn_create_lobby',
			button = 'spdrn_create_lobby',
			colour = G.C.GREEN,
			minw = 3.65,
			minh = 1.55,
			label = localize('b_create_lobby_cap'),
			scale = 0.7,
			col = true,
			enabled = _connected,
		})
		_join_by_code_button = MPAPI.disableable_button({
			id = 'spdrn_join_lobby_by_code',
			button = 'spdrn_join_lobby_by_code',
			colour = G.C.RED,
			minw = 3.65,
			minh = 0.6,
			label = { localize('b_by_code_cap') },
			scale = 0.45,
			enabled = _connected,
		})
		_join_from_clipboard_button = MPAPI.disableable_button({
			id = 'spdrn_join_lobby_from_clipboard',
			button = 'spdrn_join_lobby_from_clipboard',
			colour = G.C.PURPLE,
			minw = 3.65,
			minh = 0.6,
			label = { localize('b_from_clipboard_cap') },
			scale = 0.45,
			enabled = _connected,
		})
		_practice_button = MPAPI.disableable_button({
			id = 'spdrn_practice',
			button = 'spdrn_practice',
			colour = G.C.ORANGE,
			minw = 2.65,
			minh = 1.35,
			label = { localize('b_practice_cap') },
			scale = 0.54,
			col = true,
			enabled = true,
		})
	end

	_buttons_initialized = true
end

-----------------------------
-- LOGIC FUNCTIONS
-----------------------------

SPDRN.update_main_menu_buttons = function()
	if _buttons_initialized then
		_find_game_button:update()
		_create_lobby_button:update()
		_join_by_code_button:update()
		_join_from_clipboard_button:update()
	end
end

G.FUNCS.spdrn_create_lobby = function() end

G.FUNCS.spdrn_join_lobby_by_code = function() end

G.FUNCS.spdrn_join_lobby_from_clipboard = function() end

G.FUNCS.spdrn_practice = function() end
