local util = require("util")
local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

-- kill the current workspace and switch back to the previous workspace
M.kill_workspace = function(window, pane, workspace)
	local success, stdout =
		wezterm.run_child_process({ "/opt/homebrew/bin/wezterm", "cli", "list", "--format=json" })

	if success then
		local json = wezterm.json_parse(stdout)
		if not json then
			return
		end

		local workspace_panes = util.filter(json, function(p)
			return p.workspace == workspace
		end)

		M.switch_to_previous_workspace(window, pane)
		wezterm.GLOBAL.previous_workspace = nil

		for _, p in ipairs(workspace_panes) do
			wezterm.run_child_process({
				"/opt/homebrew/bin/wezterm",
				"cli",
				"kill-pane",
				"--pane-id=" .. p.pane_id,
			})
		end
	end
end

M.switch_workspace = function(window, pane, workspace)
	local current_workspace = window:active_workspace()
	if current_workspace == workspace then
		return
	end

	window:perform_action(
		act.SwitchToWorkspace({
			name = workspace,
		}),
		pane
	)
	wezterm.GLOBAL.previous_workspace = current_workspace
end

M.switch_to_previous_workspace = function(window, pane)
	local current_workspace = window:active_workspace()
	local workspace = wezterm.GLOBAL.previous_workspace

	if current_workspace == workspace or wezterm.GLOBAL.previous_workspace == nil then
		return
	end

	M.switch_workspace(window, pane, workspace)
end

return M
