-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LazyVim picker to use.
-- Can be one of: telescope, fzf
vim.g.lazyvim_picker = "fzf"

local api = vim.api
api.nvim_command("syntax on")
api.nvim_command("filetype plugin indent on")

-- Setting window-scoped options
local wo = vim.wo
wo.numberwidth = 6

local opt = vim.opt
opt.modeline = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

----------------------------------------------------------------------------
-- Backup
-----------------------------------------------------------------------------
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-----------------------------------------------------------------------------
-- Search
-----------------------------------------------------------------------------
opt.wrapscan = false -- Search wraps at end of file
opt.scrolljump = 5   -- Lines to scroll when cursor leaves screen
opt.showmatch = true
opt.incsearch = true -- Find as you type search
opt.hlsearch = true  -- Highlight search terms
