-- Pull in the wezterm API
local wezterm = require("wezterm")

-- refactored configs
local design = require("design")
local keybinds = require("keybinds")
local launch_menu = require("launch_menu")
local startup = require("gui_startup")
local status = require("status")

-- This table will hold the configuration.
local config = wezterm.config_builder()

config = {
	unix_domains = {
		{
			name = "unix",
		},
	},
	-- config.default_gui_startup_args = { "connect", "unix" }

	ssh_domains = {
		{
			name = "raspi",
			remote_address = "rpi.local",
			username = "tjex",
		},
	},

	-- disables mac unicode symbol input via ALT/META
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = true,

	front_end = "WebGpu",
	audible_bell = "Disabled",
	default_workspace = "admin",
	-- automatically_reload_config = false,
	status_update_interval = 200,

	skip_close_confirmation_for_processes_named = {
		"bash",
		"sh",
		"zsh",
	},
}

-- apply the conf files required above
design.apply(config)
keybinds.apply(config)
launch_menu.apply(config)

status.load()
startup.start()

return config
