local wezterm = require("wezterm")

local TABINACTIVE_TRANSPARENCY = 0.2
local BASE_BG_COLOR = "#000000"
local BASE_TAB_BG_COLOR = "0,0,0"

local is_transparent = true
local transparency = 0.75
local fs = 12

local setColors = function(term_bg_hex, term_bg_rgb)
	return {
		background = term_bg_hex,
		cursor_bg = "#e6c200",
		cursor_fg = "#1c1c1c",
		cursor_border = "#e6c200",
		tab_bar = {
			background = "rgba(" .. term_bg_rgb .. "," .. transparency .. ")",
			active_tab = {
				bg_color = "rgba(" .. term_bg_rgb .. "," .. transparency .. ")",
				fg_color = "#ffffff",
			},
			inactive_tab = {
				bg_color = "rgba(" .. term_bg_rgb .. "," .. transparency .. ")",
				fg_color = "#888888",
			},
			inactive_tab_hover = {
				bg_color = "rgba(" .. term_bg_rgb .. "," .. TABINACTIVE_TRANSPARENCY .. ")",
				fg_color = "#aaaaaa",
			},
			new_tab = {
				bg_color = "rgba(" .. term_bg_rgb .. "," .. transparency .. ")",
				fg_color = "#00ff00",
			},
			new_tab_hover = {
				bg_color = "rgba(" .. term_bg_rgb .. "," .. TABINACTIVE_TRANSPARENCY .. ")",
				fg_color = "#00ff00",
			},
		},
	}
end
local colors = setColors("#000000", "0,0,0")

local setWindow = function(window)
	if not is_transparent then
		window:set_config_overrides({
			window_background_opacity = 1.0,
			colors = colors,
			font_size = fs,
		})
	else
		window:set_config_overrides({
			window_background_opacity = transparency,
			colors = colors,
			font_size = fs,
		})
	end
end

wezterm.on("toggle-transparency", function(window)
	is_transparent = not is_transparent

	if is_transparent then
		colors = setColors("#000000", "0,0,0")
		setWindow(window)
	else
		colors = setColors(BASE_BG_COLOR, BASE_TAB_BG_COLOR)
		setWindow(window)
	end
end)

wezterm.on("increase-transparency", function(window)
	if is_transparent and transparency - 0.05 >= 0 then
		transparency = transparency - 0.05
		setWindow(window)
	end
end)

wezterm.on("decrease-transparency", function(window)
	if is_transparent and transparency + 0.05 <= 1 then
		transparency = transparency + 0.05
		setWindow(window)
	end
end)

wezterm.on("increase-font", function(window)
	fs = fs + 1
	setWindow(window)
end)

wezterm.on("decrease-font", function(window)
	fs = fs - 1
	setWindow(window)
end)

wezterm.on("default-font", function(window)
	fs = 12
	setWindow(window)
end)

return {
	window_background_opacity = is_transparent and transparency or 1.0,
	font = wezterm.font_with_fallback({
		{
			family = "Jetbrains Mono Nerd Font",
			weight = "Bold",
		},
		{
			family = "Noto Sans JP",
			weight = "Bold",
		},
	}),
	font_size = fs,

	color_scheme = "Kanagawa Dragon (Gogh)",
	colors = colors,

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
		{ key = "R", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("increase-transparency") },
		{ key = "L", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("decrease-transparency") },
		{ key = "D", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("increase-font") },
		{ key = "B", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("decrease-font") },
		{ key = "F", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("default-font") },
	},

	use_ime = true,
}
