local wezterm = require("wezterm")
local is_transparent = true

wezterm.on("toggle-transparency", function(window, pane)
	is_transparent = not is_transparent

	if is_transparent then
		window:set_config_overrides({
			window_background_opacity = 0.85,
			colors = {
				background = "#000000",
			},
		})
	else
		window:set_config_overrides({
			window_background_opacity = 1.0,
			colors = {
				background = "#1f212b",
			},
		})
	end
end)

return {
	window_background_opacity = is_transparent and 0.85 or 1.0,
	font = wezterm.font("Jetbrains Mono Nerd Font"),
	font_size = 12.0,

	color_scheme = "Kanagawa Dragon (Gogh)",
	colors = {
		cursor_bg = "#e6c200",
		cursor_fg = "#1c1c1c",
		cursor_border = "#e6c200",
		tab_bar = {
			background = "rgba(0,0,0,0.8)",
			active_tab = {
				bg_color = "rgba(0,0,0,0.8)",
				fg_color = "#ffffff",
			},
			inactive_tab = {
				bg_color = "rgba(0,0,0,0.8)",
				fg_color = "#888888",
			},
			inactive_tab_hover = {
				bg_color = "rgba(0,0,0,0.2)",
				fg_color = "#aaaaaa",
			},
			new_tab = {
				bg_color = "rgba(0,0,0,0.8)",
				fg_color = "#00ff00",
			},
			new_tab_hover = {
				bg_color = "rgba(0,0,0,0.2)",
				fg_color = "#00ff00",
			},
		},
	},

	tab_bar_at_bottom = false,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,

	keys = {
		{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
		{
			key = "X",
			mods = "CTRL|SHIFT",
			action = wezterm.action.Multiple({
				wezterm.action.CopyTo("Clipboard"),
				wezterm.action.SendKey({ key = "Delete", mods = "" }),
			}),
		},
		{ key = "Space", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
		{ key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
		{ key = "W", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
		{ key = "T", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("toggle-transparency") },
	},
}
