in_wsl = os.getenv('WSL_DISTRO_NAME') ~= nil

if in_wsl then
  vim.g.clipboard = {
    name = 'wsl clipboard',
    copy = {
      ["+"] = { "/mnt/c/Windows/system32/clip.exe" },
      ["*"] = { "/mnt/c/Windows/system32/clip.exe" }
    },
    paste = {
      ["+"] = { "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))" },
      ["*"] = { "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))" }
    },
    cache_enabled = false
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
      { out,                            "WarningMsg" },
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
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true },
})

-- colorscheme options
require("tokyonight").setup({
  style = "night",
})
vim.cmd[[colorscheme tokyonight]]

-- Disable Mousevim.opt.mousescroll = "ver:0,hor:0"
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })

vim.opt.mouse = ""
