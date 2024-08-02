local wezterm = require("wezterm")
local mux = wezterm.mux
local M = {}

local function admin(choice)
	if choice == "laptop" then
		-- define tabs
		local admin_tab, admin_pane, admin_window = mux.spawn_window({
			workspace = "admin",
			cwd = "/Users/tjex/docs/",
		})

		local rss_tab, rss_pane = admin_window:spawn_tab({})

		local matrix_tab, matrix_pane = admin_window:spawn_tab({})

		local music_tab = admin_window:spawn_tab({
			cwd = "/Users/tjex/audio/atmos",
		})

		-- change layout depending on monitor choice
		admin_tab:set_title("aerc")
		admin_pane:send_text("aerc\n")
		music_tab:set_title("atmos")

		rss_tab:set_title("rss")
		rss_pane:send_text("newsboat\n")

		matrix_tab:set_title("matrix")
		matrix_pane:send_text("iamb\n")
		return
	end
	local admin_tab, term = mux.spawn_window({
		workspace = "admin",
		cwd = "/Users/tjex/docs/",
	})

	admin_tab:set_title("aerc")

	local aerc = term:split({ direction = "Right", size = 0.666 })
	aerc:send_text("aerc\n")

	local lf = aerc:split({ direction = "Right", size = 0.5 })
	lf:send_text("lf\n")

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
	local writing_tab, writing_pane, _ = mux.spawn_window({
		workspace = "writing",
		cwd = "/Users/tjex/wikis/ps",
	})
	writing_tab:set_title("ps")
	writing_pane:send_text("zk start\n")
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
