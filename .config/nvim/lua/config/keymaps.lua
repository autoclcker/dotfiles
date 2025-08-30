-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("c", "<C-a>", "<Home>", { desc = "Move cursor to the beginning of the line start in command mode" })
vim.keymap.set("c", "<C-e>", "<End>", { desc = "Move cursor to the end of the line in command mode" })
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Move cursor right in insert mode" })
vim.keymap.set("i", "<C-b>", "<Left>", { desc = "Move cursor left in insert mode" })
vim.keymap.set("i", "<M-f>", "<C-Right>", { desc = "Move one word forward in insert mode" })
vim.keymap.set("i", "<M-b>", "<C-Left>", { desc = "Move one word backward in insert mode" })
vim.keymap.set("n", "<leader>1", "1<C-w>w", { desc = "Switch to split 1" })
vim.keymap.set("n", "<leader>2", "2<C-w>w", { desc = "Switch to split 2" })
vim.keymap.set("n", "<leader>3", "3<C-w>w", { desc = "Switch to split 3" })
vim.keymap.set("n", "<leader>4", "4<C-w>w", { desc = "Switch to split 4" })
vim.keymap.set("n", "<leader>5", "5<C-w>w", { desc = "Switch to split 5" })
vim.keymap.set("n", "<leader>6", "6<C-w>w", { desc = "Switch to split 6" })
vim.keymap.set("n", "<leader>7", "7<C-w>w", { desc = "Switch to split 7" })
vim.keymap.set("n", "<leader>8", "8<C-w>w", { desc = "Switch to split 8" })
vim.keymap.set("n", "<leader>9", "9<C-w>w", { desc = "Switch to split 9" })
vim.keymap.set("n", "<leader>'", "<C-w>p", { desc = "Switch to the last visited split" })
vim.keymap.del("n", "<C-l>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-h>")
vim.keymap.set("t", "<M-t>", "<cmd>close<cr>", { desc = "Hide Terminal" })

