-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("c", "<C-a>", "<Home>", { desc = "Move cursor to the beginning of the line start in command mode" })
vim.keymap.set("c", "<C-e>", "<End>", { desc = "Move cursor to the end of the line in command mode" })
vim.keymap.set("c", "<C-f>", "<Right>", { desc = "Move cursor right in command mode" })
vim.keymap.set("c", "<C-b>", "<Left>", { desc = "Move cursor left in command mode" })
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Move cursor right in insert mode" })
vim.keymap.set("i", "<C-b>", "<Left>", { desc = "Move cursor left in insert mode" })
vim.keymap.set("i", "<M-f>", "<C-Right>", { desc = "Move one word forward in insert mode" })
vim.keymap.set("i", "<M-b>", "<C-Left>", { desc = "Move one word backward in insert mode" })
