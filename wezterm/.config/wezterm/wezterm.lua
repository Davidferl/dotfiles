local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action
local mod = {}

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

local shell_path = "/usr/bin/fish"

if wezterm.target_triple:find("darwin") then
	shell_path = "/opt/homebrew/bin/fish"
end

config.default_prog = { shell_path, "-l" }

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 11.0

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.90
config.use_dead_keys = false
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.7 }

config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false

mod.SUPER = "ALT"
mod.SUPER_REV = "ALT|CTRL"

config.keys = {

	-- tabs --
	{ key = "h", mods = mod.SUPER, action = act.ActivateTabRelative(-1) },
	{ key = "l", mods = mod.SUPER, action = act.ActivateTabRelative(1) },
	{ key = "[", mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
	{ key = "]", mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },
	{
		key = "t",
		mods = "SHIFT|ALT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- panes --
	-- panes: split panes
	{
		key = [[\]],
		mods = mod.SUPER,
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = [[\]],
		mods = mod.SUPER_REV,
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- navigation --
	{ key = "k", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Down") },
	{ key = "h", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Right") },
	{
		key = "p",
		mods = mod.SUPER_REV,
		action = act.PaneSelect({ alphabet = "1234567890", mode = "SwapWithActiveKeepFocus" }),
	},
}

local custom = wezterm.color.get_builtin_schemes()["Tokyo Night"]
custom.tab_bar.inactive_tab.fg_color = "#9aa5ce"
custom.tab_bar.active_tab.fg_color = "#9ece6a"

config.color_schemes = {
	["Tokyo Night Custom"] = custom,
}

config.color_scheme = "nord"

return config
