local wezterm = require("wezterm")
local mux = wezterm.mux
local M = {}

local function admin()
	local admin_tab = mux.spawn_window({
		workspace = "admin",
		cwd = "/Users/tjex/docs/",
	})

	admin_tab:set_title("admin")
end

local function sys()
	local sys_tab = mux.spawn_window({
		workspace = "config",
		cwd = "/Users/tjex/.config",
	})
	sys_tab:set_title("config")
end

local function dev()
	local dev_tab, _, dev_window = mux.spawn_window({
		workspace = "dev",
		cwd = "/Users/tjex/.local/src",
	})
	dev_tab:set_title("dev")

	local zkorg_tab = dev_window:spawn_tab({
		cwd = "/Users/tjex/projects/zk-org/",
	})
	zkorg_tab:set_title("zk-org")
end

local function writing()
	local ps_tab, ps_pane, writing_window = mux.spawn_window({
		workspace = "writing",
		cwd = "/Users/tjex/wikis/ps",
	})
	ps_tab:set_title("ps")
	ps_pane:send_text("zk start\n")

	local tech_tab = writing_window:spawn_tab({
		cwd = "/Users/tjex/wikis/tech",
	})
	tech_tab:set_title("tech")

	local lang_tab = writing_window:spawn_tab({
		cwd = "/Users/tjex/wikis/lang",
	})
	lang_tab:set_title("lang")
end

function M.start()
	wezterm.on("gui-startup", function()
		admin()
		sys()
		dev()
		writing()
	end)
end

return M
