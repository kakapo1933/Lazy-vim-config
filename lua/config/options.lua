-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Force global statusline ALWAYS
vim.opt.laststatus = 3

-- Ensure it stays global even after plugins load
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.opt.laststatus = 3
  end,
})
