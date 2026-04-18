-- Forward declaration for helper function
local create_buttons

-----------------------------
-- STATE VARIABLES
-----------------------------

local _pending_gamemode_key = nil

local _find_game_button
local _create_lobby_button
local _join_by_code_button
local _join_from_clipboard_button
local _practice_button
local _buttons_initialized = false

-----------------------------
-- UI FUNCTIONS
-----------------------------

SPDRN.build_pre_lobby_ui = function()
	create_buttons()
	MPAPI.set_logo_offset(0, true)
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
											{ n = G.UIT.T, config = { text = localize('k_join_lobby_cap'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, vert = true, maxh = 1.4 } },
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
			label = { localize('b_find_game_cap') },
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
			enabled = MPAPI.is_connected(),
		})
		_join_by_code_button = MPAPI.disableable_button({
			id = 'spdrn_join_lobby_by_code',
			button = 'spdrn_join_lobby_by_code',
			colour = G.C.RED,
			minw = 3.65,
			minh = 0.6,
			label = { localize('b_by_code_cap') },
			scale = 0.45,
			enabled = MPAPI.is_connected(),
		})
		_join_from_clipboard_button = MPAPI.disableable_button({
			id = 'spdrn_join_lobby_from_clipboard',
			button = 'spdrn_join_lobby_from_clipboard',
			colour = G.C.PURPLE,
			minw = 3.65,
			minh = 0.6,
			label = { localize('b_from_clipboard_cap') },
			scale = 0.45,
			enabled = MPAPI.is_connected(),
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

G.FUNCS.spdrn_gm_shadows = function(e)
	e.shadow_parrallax = { x = 0, y = -1.5 * e.config.minh ^ 0.25 }
end

G.FUNCS.spdrn_create_lobby = function()
	G.FUNCS.overlay_menu({
		definition = create_UIBox_generic_options({
			contents = {
				{ n = G.UIT.R, config = { align = 'cm', padding = 0.1 }, nodes = {
					{ n = G.UIT.T, config = { text = 'Select Gamemode', scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
				} },
				{
					n = G.UIT.R,
					config = { align = 'cm' },
					nodes = {
						{
							n = G.UIT.C,
							config = { align = 'cm', padding = 0.05 },
							nodes = {
								UIBox_button({
									id = 'spdrn_gm_white_triple',
									button = 'spdrn_select_white_stake_triple',
									label = { 'White', 'Stake', 'Triple' },
									colour = G.C.ETERNAL,
									minw = 1,
									minh = 3.2,
									scale = 0.5,
									func = 'spdrn_gm_shadows',
								}),
							},
						},
						{
							n = G.UIT.C,
							config = { align = 'cm' },
							nodes = {
								{
									n = G.UIT.R,
									config = { align = 'cm' },
									nodes = {
										{
											n = G.UIT.C,
											config = { align = 'cm', padding = 0.05 },
											nodes = {
												UIBox_button({
													id = 'spdrn_gm_gold_triple',
													button = 'spdrn_select_gold_stake_single',
													label = { 'Seed', 'Scout' },
													colour = G.C.BLUE,
													minw = 1,
													minh = 2.1,
													scale = 0.5,
													func = 'spdrn_gm_shadows',
												}),
											},
										},
										{
											n = G.UIT.C,
											config = { align = 'cm' },
											nodes = {
												{
													n = G.UIT.R,
													config = { align = 'cm', padding = 0.05 },
													nodes = {
														UIBox_button({ id = 'spdrn_gm_challenge', button = 'spdrn_select_challenge', label = { 'Challenge' }, colour = G.C.RED, minw = 2.1, minh = 1, scale = 0.5, func = 'spdrn_gm_shadows' }),
													},
												},
												{
													n = G.UIT.R,
													config = { align = 'cm' },
													nodes = {
														{
															n = G.UIT.C,
															config = { align = 'cm', padding = 0.05 },
															nodes = {
																UIBox_button({
																	id = 'spdrn_gm_all_deck',
																	button = 'spdrn_select_all_deck',
																	label = { 'All', 'Deck' },
																	colour = G.C.PURPLE,
																	minw = 1,
																	minh = 1,
																	scale = 0.5,
																	func = 'spdrn_gm_shadows',
																}),
															},
														},
														{
															n = G.UIT.C,
															config = { align = 'cm', padding = 0.05 },
															nodes = {
																UIBox_button({
																	id = 'spdrn_gm_stake_climb',
																	button = 'spdrn_select_stake_climb',
																	label = { 'Stake', 'Climb' },
																	colour = G.C.GREEN,
																	minw = 1,
																	minh = 1,
																	scale = 0.5,
																	func = 'spdrn_gm_shadows',
																}),
															},
														},
													},
												},
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = { align = 'cm', padding = 0.05 },
									nodes = {
										UIBox_button({ id = 'spdrn_gm_gold', button = 'spdrn_select_gold_stake_single', label = { 'Gold Stake Single' }, colour = G.C.GOLD, minw = 3.2, minh = 1, scale = 0.5, func = 'spdrn_gm_shadows' }),
									},
								},
							},
						},
					},
				},
			},
		}),
	})
end

local function create_lobby_with_gamemode(key)
	_pending_gamemode_key = key
	G.FUNCS.exit_overlay_menu()

	local gm = MPAPI.GameModes[key]
	local lobby = MPAPI.create_lobby(SPDRN.id, { max_players = gm and gm:get_max_players('private') or 16 })
	if not lobby then
		_pending_gamemode_key = nil
		return
	end

	SPDRN.setup_lobby_events(lobby)

	lobby:on('connected', function()
		SPDRN.sendDebugMessage('Lobby created: ' .. tostring(lobby.code))
		love.system.setClipboardText(lobby.code)
		SPDRN.sendDebugMessage('Code copied to clipboard')
		if _pending_gamemode_key then
			lobby:set_metadata({ gamemode = _pending_gamemode_key, deck = 'Blue Deck' })
			_pending_gamemode_key = nil
		end
	end)
end

G.FUNCS.spdrn_select_white_stake_triple = function()
	create_lobby_with_gamemode('spdrn_white_stake_triple')
end

G.FUNCS.spdrn_select_gold_stake_single = function()
	create_lobby_with_gamemode('spdrn_gold_stake_single')
end

G.FUNCS.spdrn_join_lobby_by_code = function()
	G.FUNCS.overlay_menu({
		definition = create_UIBox_generic_options({
			snap_back = true,
			contents = {
				{
					n = G.UIT.R,
					config = { align = 'cm', padding = 0.2, r = 0.1 },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = 'cm', padding = 0.05 },
							nodes = {
								{ n = G.UIT.T, config = { text = localize('k_lobby_code_cap'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
							},
						},
						{
							n = G.UIT.R,
							config = { align = 'cm', padding = 0.1 },
							nodes = {
								create_text_input({ id = 'spdrn_lobby_code_input', ref_table = { text = '' }, ref_value = 'text', prompt_text = localize('k_lobby_code_cap'), max_length = 6, all_caps = true, w = 4, h = 0.6 }),
							},
						},
						{
							n = G.UIT.R,
							config = { align = 'cm', padding = 0.1 },
							nodes = {
								UIBox_button({ id = 'spdrn_join_lobby_confirm', button = 'spdrn_join_lobby_confirm', colour = G.C.GREEN, minw = 2, minh = 0.6, label = { localize('k_join_lobby_cap') }, scale = 0.45 }),
							},
						},
					},
				},
			},
		}),
	})
end

G.FUNCS.spdrn_join_lobby_confirm = function()
	local code = G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('spdrn_lobby_code_input')
	if code and code.config and code.config.ref_table then
		local text = code.config.ref_table.text or ''
		text = text:match('^%s*(.-)%s*$') or ''
		if #text > 0 then
			G.FUNCS.exit_overlay_menu()
			SPDRN._join_lobby_with_code(text)
		end
	end
end

G.FUNCS.spdrn_join_lobby_from_clipboard = function()
	local code = love.system.getClipboardText() or ''
	code = code:match('^%s*(.-)%s*$') or ''
	if #code > 0 then
		SPDRN._join_lobby_with_code(code)
	end
end

SPDRN._join_lobby_with_code = function(code)
	local lobby = MPAPI.join_lobby(SPDRN.id, code)
	if not lobby then
		return
	end

	SPDRN.setup_lobby_events(lobby)

	lobby:on('connected', function()
		SPDRN.sendDebugMessage('Joined lobby: ' .. tostring(lobby.code))
		-- UI transition is driven by MPAPI.on_lobby_connected
	end)

	lobby:on('metadata_changed', function(metadata)
		SPDRN.sendDebugMessage('Metadata changed')
	end)
end

G.FUNCS.spdrn_find_game = function() end

G.FUNCS.spdrn_practice = function() end
