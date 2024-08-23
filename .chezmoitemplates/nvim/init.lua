In_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil

if In_wsl then
	vim.g.clipboard = {
		name = "wsl clipboard",
		copy = {
			["+"] = { "/mnt/c/Windows/system32/clip.exe" },
			["*"] = { "/mnt/c/Windows/system32/clip.exe" },
		},
		paste = {
			["+"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe" },
			["*"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe" },
		},
		cache_enabled = false,
	}
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
	},
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = true },
})

local custom_tokyonight = require("lualine.themes.tokyonight")
custom_tokyonight.normal.c.bg = "#1a1b26"

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = custom_tokyonight,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", separator = { right = "" }, color = { bg = "#292e42" } } },
		lualine_x = {
			{ "encoding", separator = { left = "" }, color = { bg = "#bb9af7", fg = "#1f2335" } },
			{ "fileformat", separator = { left = "" }, color = { bg = "#9d7cd8", fg = "#1f2335" } },
			{ "filetype", separator = { left = "" }, color = { bg = "#414868", fg = "#ffffff" } },
		},
		lualine_y = { { "progress", color = { bg = "#c53b53", fg = "#ffffff" } } },
		lualine_z = {
			{
				"location",
				separator = { left = "", right = "" },
				color = { bg = "#ff007c", fg = "#ffffff" },
				left_padding = 2,
			},
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

-- colorscheme options
require("tokyonight").setup({
	style = "night",
	on_colors = function() end,
	on_highlights = function() end,
})
vim.cmd([[colorscheme tokyonight]])

-- Disable Mousevim.opt.mousescroll = "ver:0,hor:0"
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })

vim.opt.mouse = ""
