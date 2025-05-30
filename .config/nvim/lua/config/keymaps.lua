-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- move stuff in visual mode with J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Map Ctrl+j to behave like Ctrl+d in normal and visual mode
vim.api.nvim_set_keymap("n", "<C-j>", "<C-d>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-j>", "<C-d>", { noremap = true, silent = true })
