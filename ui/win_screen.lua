-----------------------------
-- Win screen
-----------------------------

function SPDRN.create_win_screen()
	local eased_green = copy_table(G.C.GREEN)
	eased_green[4] = 0
	ease_value(eased_green, 4, 0.5, nil, nil, true)

	local t = create_UIBox_generic_options({
		padding = 0,
		bg_colour = eased_green,
		colour = G.C.BLACK,
		outline_colour = G.C.EDITION,
		no_back = true,
		no_esc = true,
		contents = {
			{
				n = G.UIT.R,
				config = { align = 'cm' },
				nodes = {
					{ n = G.UIT.O, config = { object = DynaText({ string = { localize('ph_you_win') }, colours = { G.C.EDITION }, shadow = true, float = true, spacing = 10, rotate = true, scale = 1.5, pop_in = 0.4, maxw = 6.5 }) } },
				},
			},
			{
				n = G.UIT.R,
				config = { align = 'cm', padding = 0.15 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'cm' },
						nodes = {
							{ n = G.UIT.R, config = { align = 'cm', padding = 0.08 }, nodes = {
								create_UIBox_round_scores_row('hand'),
								create_UIBox_round_scores_row('poker_hand'),
							} },
							{
								n = G.UIT.R,
								config = { align = 'cm' },
								nodes = {
									{
										n = G.UIT.C,
										config = { align = 'cm', padding = 0.08 },
										nodes = {
											create_UIBox_round_scores_row('cards_played', G.C.BLUE),
											create_UIBox_round_scores_row('cards_discarded', G.C.RED),
											create_UIBox_round_scores_row('cards_purchased', G.C.MONEY),
											create_UIBox_round_scores_row('times_rerolled', G.C.GREEN),
											create_UIBox_round_scores_row('new_collection', G.C.WHITE),
											create_UIBox_round_scores_row('seed', G.C.WHITE),
											UIBox_button({ button = 'copy_seed', label = { localize('b_copy') }, colour = G.C.BLUE, scale = 0.3, minw = 2.3, minh = 0.4 }),
										},
									},
									{
										n = G.UIT.C,
										config = { align = 'tr', padding = 0.08 },
										nodes = {
											create_UIBox_round_scores_row('furthest_ante', G.C.FILTER),
											create_UIBox_round_scores_row('furthest_round', G.C.FILTER),
											{ n = G.UIT.R, config = { align = 'cm', minh = 0.2, minw = 0.1 }, nodes = {} },
											UIBox_button({
												button = 'spdrn_continue_sp',
												label = { 'Continue in Singleplayer' },
												colour = G.C.BLUE,
												minw = 2.5,
												maxw = 2.5,
												minh = 0.85,
												scale = 0.32,
												focus_args = { nav = 'wide', snap_to = true },
											}),
											UIBox_button({ button = 'spdrn_return_to_lobby', label = { 'Return to Lobby' }, colour = G.C.GREEN, minw = 2.5, maxw = 2.5, minh = 0.85, scale = 0.32, focus_args = { nav = 'wide' } }),
											UIBox_button({ button = 'spdrn_leave_from_game', label = { 'Leave Lobby' }, colour = G.C.RED, minw = 2.5, maxw = 2.5, minh = 0.85, scale = 0.32, focus_args = { nav = 'wide' } }),
										},
									},
								},
							},
						},
					},
				},
			},
		},
	})

	t.nodes[1] = {
		n = G.UIT.R,
		config = { align = 'cm', padding = 0.1 },
		nodes = {
			{ n = G.UIT.C, config = { align = 'cm', padding = 2 }, nodes = {
				{ n = G.UIT.O, config = { padding = 0, id = 'jimbo_spot', object = Moveable(0, 0, G.CARD_W * 1.1, G.CARD_H * 1.1) } },
			} },
			{ n = G.UIT.C, config = { align = 'cm', padding = 0.1 }, nodes = { t.nodes[1] } },
		},
	}
	t.config.id = 'spdrn_win_UI'

	return t
end

SPDRN.show_win_screen = function()
	play_sound('win')
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = SPDRN.create_win_screen(),
		config = { no_esc = true },
	})

	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 2.5,
		blocking = false,
		func = function()
			if G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot') then
				local Jimbo = Card_Character({ x = 0, y = 5 })
				local spot = G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot')
				spot.config.object:remove()
				spot.config.object = Jimbo
				Jimbo.ui_object_updated = true
				Jimbo:add_speech_bubble('wq_' .. math.random(1, 7), nil, { quip = true })
				Jimbo:say_stuff(5)
			end
			return true
		end,
	}))
end
