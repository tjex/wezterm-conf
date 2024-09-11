local wezterm = require("wezterm")
local mux = wezterm.mux
local M = {}

local function admin(choice)
	if choice == "laptop" then
		-- define tabs
		local admin_tab, admin_pane = mux.spawn_window({
			workspace = "admin",
			cwd = "/Users/tjex/docs/",
		})

		admin_tab:set_title("aerc")
		admin_pane:send_text("aerc\n")
		return
	end
	local admin_tab, admin_pane = mux.spawn_window({
		workspace = "admin",
		cwd = "/Users/tjex/docs/",
	})

	admin_tab:set_title("aerc")

	local aerc = admin_pane:split()
	aerc:send_text("aerc\n")

	aerc:activate()
end

local function sys()
	local sys_tab = mux.spawn_window({
		workspace = "sys",
		cwd = "/Users/tjex/.config",
	})
	sys_tab:set_title("config")
end

local function dev()
	local dev_tab, _, dev_window = mux.spawn_window({
		workspace = "dev",
		cwd = "/Users/tjex/dev/",
	})

	dev_tab:set_title("dev")

	local lsrc_tab = dev_window:spawn_tab({
		cwd = "/Users/tjex/.local/src",
	})
	lsrc_tab:set_title(".local/src")

	local zkorg_tab = dev_window:spawn_tab({
		cwd = "/Users/tjex/.local/src/zk-org/",
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

	local diary_tab = writing_window:spawn_tab({
		cwd = "/Users/tjex/wikis/diary",
	})
	diary_tab:set_title("diary")

	local tech_tab = writing_window:spawn_tab({
		cwd = "/Users/tjex/wikis/tech",
	})
	tech_tab:set_title("tech")

	local lang_tab = writing_window:spawn_tab({
		cwd = "/Users/tjex/wikis/lang",
	})
	lang_tab:set_title("lang")
end

function M.start(choice)
	wezterm.on("gui-startup", function()
		admin(choice)
		sys()
		dev()
		writing()
	end)
end

return M
