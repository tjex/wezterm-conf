local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local fd = "/opt/homebrew/bin/fd"
local lsrc = "/Users/tjex/.local/src"
local dev = "/Users/tjex/dev"
local projects = "/Users/tjex/projects"
local scratch = "/Users/tjex/scratch/"

-- from https://github.com/wez/wezterm/discussions/4796
M.open = function(window, pane)
	local repos = {}
	local home = os.getenv("HOME") .. "/"

	local success, stdout, stderr = wezterm.run_child_process({
		fd,
		"-HI",
		".git$",
		"--max-depth=4",
		"--prune",
		lsrc,
		dev,
		projects,
		scratch,
		-- add more paths here
	})

	if not success then
		wezterm.log_error("Sessionizera: failed to run fd. " .. stderr)
		return
	end

	-- define variables from from file paths extractions and
	-- fill table with results
	for line in stdout:gmatch("([^\n]*)\n?") do
		-- create label from file path
		local project = line:gsub("/.git.*", "")
		project = project:gsub("/$", "")
		local label = project:gsub(home, "")

		-- extract id. Used for workspace name
		local _, _, id = string.find(project, ".*/(.+)")
		id = id:gsub(".git", "") -- bare repo dirs typically end in .git, remove if so.

		table.insert(repos, { label = tostring(label), id = tostring(id) })
	end

	-- update previous_workspace before changing to new workspace.
	wezterm.GLOBAL.previous_workspace = window:active_workspace()
	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					return
				else
					win:perform_action(
						act.SwitchToWorkspace({
							name = id,
							spawn = { cwd = home .. label },
						}),
						pane
					)
				end
			end),
			fuzzy = true,
			title = "Select project",
			choices = repos,
		}),
		pane
	)
end

return M
