-- for window / UI status output

local wezterm = require("wezterm")
local mux = wezterm.mux
local M = {}

function M.load()
	-- doc: https://wezfurlong.org/wezterm/config/lua/window/set_right_status.html
	wezterm.on("update-right-status", function(window, pane)
		local cells = {}
		local elements = {}
		local num_cells = 0
		local bg = "#1a1c23"
		local text_fg = "#b1b1b1"
		local yellow = "#d8a274"
		local workspace = mux.get_active_workspace()

		local function getKeytable()
			local name = window:active_key_table()
			if name then
				table.insert(cells, name)
			end
		end

		local function getHostname()
			local hostname = wezterm.hostname()
			local dot = hostname:find("[.]")
			if dot then
				hostname = hostname:sub(1, dot - 1)
			end
			table.insert(cells, hostname)
		end

		local function getWorkspace()
			if workspace then
				table.insert(cells, workspace)
			end
		end

		local function push(text, is_last)
			if text == "pane" or text == "tabs" then
				table.insert(elements, { Foreground = { Color = yellow } })
				table.insert(elements, { Background = { Color = bg } })
				table.insert(elements, { Text = "  " .. text .. "  " })
			else
				table.insert(elements, { Foreground = { Color = text_fg } })
				table.insert(elements, { Background = { Color = bg } })
				table.insert(elements, { Text = "  " .. text .. "  " })
			end
			if not is_last then
				table.insert(elements, { Text = " | " })
			end
			num_cells = num_cells + 1
		end

		local function generateStatus()
			while #cells > 0 do
				local cell = table.remove(cells, 1)
				push(cell, #cells == 0)
			end
		end

		-- usless until I can get it to respond with ssh
		-- getHostname()
		getKeytable()
		getWorkspace()
		generateStatus()

		window:set_right_status(wezterm.format(elements))
	end)
end

return M
