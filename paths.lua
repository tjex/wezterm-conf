local M = {}

local paths = {
	"/bin:",
	"/usr/bin:",
	"/usr/local/bin:",
	"/opt/homebrew/bin:",
	"/Users/tjex/.local/go/bin:",
	"/Users/tjex/.local/share/nvm/versions/node/v20.5.1/bin:",
	"/Users/tjex/.local/share/cargo/bin:",
}

local paths_string = table.concat(paths)

function M.env_paths()
	return paths_string
end

M.home = function()
	return "/Users/tjex/"
end
M.tjex_site = function()
	return M.home() .. "projects/sites/tjex.net"
end

return M
