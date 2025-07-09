-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Move lines up/down using Control+Shift
vim.keymap.set("n", "<C-S-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<C-S-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<C-S-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<C-S-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Window resizing
vim.keymap.set("n", "<C-S-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-S-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-S-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-S-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
