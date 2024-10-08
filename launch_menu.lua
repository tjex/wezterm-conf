local util = require("util")
local M = {}

local env_paths = util.env_paths()

local function edit_config(dir)
	return {
		label = "edit" .. " " .. dir,
		cwd = "/Users/tjex/.config/" .. dir,
		set_environment_variables = {
			PATH = env_paths,
		},
		args = { "zsh", "-c", "nvim $(fd -t f | fzf)" },
	}
end

function M.apply(config)
	config.launch_menu = {
		edit_config("wezterm"),
		edit_config("nvim"),
		edit_config("aerc"),
		{
			label = "edit dotfiles",
			cwd = "/Users/tjex/.config",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "nvim $(fd -t f | fzf)" },
		},
		{
			label = "tech wiki",
			cwd = "/Users/tjex/wikis/tech/",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "nvim $(fd -t f | fzf)" },
		},
		{
			label = "lang wiki",
			cwd = "/Users/tjex/wikis/lang/",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "nvim $(fd -t f | fzf)" },
		},
		{
			label = "edit scripts",
			cwd = "/Users/tjex/.scripts",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "nvim $(fd -t f -E apple | fzf)" },
		},
		{
			label = "edit navi files",
			cwd = "/Usrs/tjex/.local/share/navi",
			set_environment_variables = {
				PATH = env_paths,
			},
			-- for some reason, this folder needs to be explicityly cd'd into?
			args = { "zsh", "-c", "cd /Users/tjex/.local/share/navi && nvim $(fd -t f | fzf)" },
		},
		{
			label = "launch aerc",
			cwd = "/Usrs/tjex/docs",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "-l", "aerc" },
		},
	}
end
return M
