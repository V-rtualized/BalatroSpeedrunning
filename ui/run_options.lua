-----------------------------
-- Custom pause/options screen for active speedrun
-----------------------------

G.FUNCS.spdrn_seed_change = function()
	-- Placeholder
end

G.FUNCS.spdrn_forfeit = function()
	G.FUNCS.exit_overlay_menu()
	local lobby = MPAPI.get_current_lobby()
	if not lobby then
		return
	end
	local action = lobby:action(MPAPI.ActionTypes['spdrn_forfeit'])
	action:broadcast({})
end

SPDRN.create_run_options = function()
	return create_UIBox_generic_options({
		contents = {
			UIBox_button({ button = 'settings', label = { localize('b_settings') }, minw = 5, focus_args = { snap_to = true } }),
			UIBox_button({ button = 'spdrn_seed_change', label = { 'Seed Change' }, minw = 5 }),
			UIBox_button({ button = 'spdrn_forfeit', label = { 'Forfeit' }, minw = 5, colour = G.C.RED }),
		},
	})
end
