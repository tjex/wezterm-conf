local b = require("functions.balance")
local func = require("functions.funcs")
local sessioniser = require("functions.sessioniser")
local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

-- custom events
require("events")

function M.apply(config)
	config.leader = { key = "o", mods = "ALT", timeout_milliseconds = 800 }

	-- LEADER KEYBINDS
	config.keys = {
		-- Send "ALT-o" to the terminal when pressing <ALT-o, CTRL-o>
		{
			key = "o",
			mods = "LEADER|CTRL",
			action = act.SendKey({ key = "o", mods = "ALT" }),
		},
		{
			key = "b",
			mods = "LEADER",
			action = wezterm.action.Multiple({
				wezterm.action_callback(b.balance_panes("x")),
			}),
		},
		{
			key = "y",
			mods = "LEADER",
			action = act.ActivateCopyMode,
		},
		{
			-- c for "capture"
			key = "c",
			mods = "LEADER",
			action = act.EmitEvent("trigger-nvim-with-scrollback"),
		},
		-- PANES
		{
			key = "x",
			mods = "LEADER",
			action = act.CloseCurrentPane({ confirm = false }),
		},
		{
			key = "v",
			mods = "LEADER",
			action = act.SplitPane({ direction = "Right", size = { Percent = 33 } }),
		},
		{
			key = "s",
			mods = "LEADER",
			action = act.SplitPane({ direction = "Down", size = { Percent = 33 } }),
		},
		-- TABS
		{
			key = "r",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, _, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		-- WORKSPACES
		{
			key = "k",
			mods = "LEADER",
			action = wezterm.action_callback(function(window, pane)
				local workspace = window:active_workspace()
				func.kill_workspace(window, pane, workspace)
			end),
		},
		-- KEY TABLES
		{
			key = "p",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "pane",
				one_shot = false,
			}),
		},
		{
			key = "t",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "tabs",
				one_shot = false,
			}),
		},

		-- "SUPER" (cmd on mac). Mainly for launching and 'generic' operations.
		-- WINDOWS / TABS / PANES
		{
			key = "w",
			mods = "SUPER",
			action = wezterm.action.CloseCurrentTab({ confirm = true }),
		},
		-- LAUNCHERS
		{
			key = "o",
			mods = "SUPER",
			action = wezterm.action_callback(sessioniser.open),
		},
		{
			key = "e",
			mods = "SUPER",
			action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
		},
		{
			key = "k",
			mods = "SUPER",
			action = act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS" }),
		},

		-- Prompt for a name to use for a new workspace and switch to it.
		{
			key = "n",
			mods = "SUPER",
			action = act.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Text = "Enter name for new workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, input)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if input then
						func.switch_workspace(window, pane, input)
					end
				end),
			}),
		},
		-- ALT Keybinds
		-- WORKSPACES
		{
			key = "s",
			mods = "ALT",
			action = wezterm.action_callback(function(window, pane)
				func.switch_to_previous_workspace(window, pane)
			end),
		},
		{
			key = "2",
			mods = "ALT",
			action = wezterm.action_callback(function(window, pane)
				func.switch_workspace(window, pane, "admin")
			end),
		},
		{
			key = "4",
			mods = "ALT",
			action = wezterm.action_callback(function(window, pane)
				func.switch_workspace(window, pane, "sys")
			end),
		},
		{
			key = "5",
			mods = "ALT",
			action = wezterm.action_callback(function(window, pane)
				func.switch_workspace(window, pane, "dev")
			end),
		},
		{
			key = "6",
			mods = "ALT",
			action = wezterm.action_callback(function(window, pane)
				func.switch_workspace(window, pane, "writing")
			end),
		},
		-- PANES
		{
			key = "h",
			mods = "ALT",
			action = act.ActivatePaneDirection("Prev"),
		},
		{
			key = "l",
			mods = "ALT",
			action = act.ActivatePaneDirection("Next"),
		},
		{
			key = "r",
			mods = "ALT",
			action = act.RotatePanes("Clockwise"),
		},
		-- COMBO
		-- i.e, (ctrl + shift + l)
		{ key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
	}

	-- KEYTABLES
	-- https://wezfurlong.org/wezterm/config/key-tables.html
	config.key_tables = {
		pane = {
			{ key = "h", action = act.AdjustPaneSize({ "Left", 2 }) },
			{ key = "l", action = act.AdjustPaneSize({ "Right", 2 }) },
			{ key = "k", action = act.AdjustPaneSize({ "Up", 2 }) },
			{ key = "j", action = act.AdjustPaneSize({ "Down", 2 }) },
			{
				key = "s",
				action = act.PaneSelect({ mode = "SwapWithActive", alphabet = "1234567890" }),
			},
			{ key = "t", action = act.PaneSelect({ mode = "MoveToNewTab" }) },

			-- exits the mode
			{ key = "Escape", action = "PopKeyTable" },
		},
		tabs = {
			{ key = "h", action = act.MoveTabRelative(-1) },
			{ key = "l", action = act.MoveTabRelative(1) },

			{ key = "Escape", action = "PopKeyTable" },
		},
	}
end

return M
