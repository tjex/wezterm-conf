local paths = require("paths")
local M = {}

local tjex_site = paths.tjex_site()
local home = paths.home()
local env_paths = paths.env_paths()

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
			label = "log",
			cwd = tjex_site .. "/src/content",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "-l", "zk log" },
		},
		{
			label = "diary",
			cwd = home .. "/wikis/diary",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "-l", "zk daily" },
		},
		{
			label = "post",
			cwd = tjex_site .. "/src/content",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "-l", 'read "var?Enter topic: " && zk post "${var}"' },
		},
		{
			label = "email",
			cwd = "/Usrs/tjex/docs",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "-l", "aerc" },
		},
		{
			label = "dotfiles",
			cwd = home .. "/.config",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "nvim $(fd -t f | fzf)" },
		},
		{
			label = "wiki tech",
			cwd = home .. "/wikis/tech/",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "nvim $(fd -t f | fzf)" },
		},
		{
			label = "wiki lang",
			cwd = home .. "/wikis/lang/",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "nvim $(fd -t f | fzf)" },
		},
		{
			label = "scripts",
			cwd = home .. "/.scripts",
			set_environment_variables = {
				PATH = env_paths,
			},
			args = { "zsh", "-c", "nvim $(fd -t f -E apple | fzf)" },
		},
		{
			label = "navi",
			cwd = "/Usrs/tjex/.local/share/navi",
			set_environment_variables = {
				PATH = env_paths,
			},
			-- for some reason, this folder needs to be explicityly cd'd into?
			args = { "zsh", "-c", "cd /Users/tjex/.local/share/navi && nvim $(fd -t f | fzf)" },
		},
	}
end
return M
