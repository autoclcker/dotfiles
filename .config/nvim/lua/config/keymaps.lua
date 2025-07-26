-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Move cursor right in insert mode" })
vim.keymap.set("i", "<C-b>", "<Left>", { desc = "Move cursor left in insert mode" })
