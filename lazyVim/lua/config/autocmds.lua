-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- $Id lua/config/autocmds.lua
--

-----------------------------------------------------------------------------
-- Terminal
-----------------------------------------------------------------------------
--[[
function _G.__split_term_right()
  execute('botright vsplit term://$SHELL')
  execute('setlocal nonumber')
  execute('setlocal norelativenumber')
  execute('startinsert')
end
--]]

local cmd = vim.cmd

cmd("command TermRight :call luaeval('_G.__split_term_right()')")
-- Directly go into insert mode when switching to terminal
cmd [[autocmd BufWinEnter,WinEnter term://* startinsert]]
-- cmd [[autocmd BufLeave term://* stopinsert]]
-- Automatically close terminal buffer on process exit
-- cmd [[autocmd TermClose term://* call nvim_input('<CR>')]]
-- cmd [[autocmd TermClose * call feedkeys("i")]]

-----------------------------------------------------------------------------
-- Executions
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Auto format
-----------------------------------------------------------------------------
vim.api.nvim_exec2([[
augroup auto_spellcheck
    autocmd!
    autocmd BufNewFile,BufRead *.md setlocal spell
    autocmd BufNewFile,BufRead *.org setfiletype markdown
    autocmd BufNewFile,BufRead *.org setlocal spell
augroup END
]], { output = false })

vim.api.nvim_exec2([[
augroup auto_term
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermOpen * startinsert
augroup END
]], { output = false })

vim.api.nvim_exec2([[
    fun! TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
    endfun

    autocmd BufWritePre * :call TrimWhitespace()
]], { output = false })

-----------------------------------------------------------------------------
-- Buffers
-----------------------------------------------------------------------------
-- In the quickfix window, <CR> is used to jump to the error under the
-- cursor, so undefine the mapping there.
cmd [[ autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR> ]]

-----------------------------------------------------------------------------
-- File indent
-----------------------------------------------------------------------------
cmd 'autocmd FileType yaml setlocal ts=2 sts=2 sw=2 autoindent expandtab'
cmd 'au BufRead,BufNewFile *.py set expandtab'
cmd 'au BufRead,BufNewFile *.c set noexpandtab'
cmd 'au BufRead,BufNewFile *.h set noexpandtab'
cmd 'au BufRead,BufNewFile Makefile* setlocal ts=8 sts=8 sw=8 set noexpandtab'

-- vim:set ts=2 sw=2 sts=2:
