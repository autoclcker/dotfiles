-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Cleanup
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
vim.keymap.del({ "n", "i" }, "<M-j>")
vim.keymap.del({ "n", "i" }, "<M-k>")
vim.keymap.del("x", "ys")
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- Normal mode
vim.keymap.set("n", "<C-l>", "<cmd>nohlsearch<cr>", { noremap = true, silent = true, desc = "Clear search" })

-- Command mode
vim.keymap.set("c", "<C-a>", "<Home>", { desc = "Move cursor to the beginning of the line start in command mode" })
vim.keymap.set("c", "<C-e>", "<End>", { desc = "Move cursor to the end of the line in command mode" })

-- Insert mode
vim.keymap.set("i", "<C-b>", "<Left>", { noremap = true, silent = true, desc = "Move cursor left in insert mode" })
vim.keymap.set("i", "<C-f>", "<Right>", { noremap = true, silent = true, desc = "Move cursor right in insert mode" })
vim.keymap.set(
  "i",
  "<M-b>",
  "<C-Left>",
  { noremap = true, silent = true, desc = "Move one word backward in insert mode" }
)
vim.keymap.set(
  "i",
  "<M-f>",
  "<C-Right>",
  { noremap = true, silent = true, desc = "Move one word forward in insert mode" }
)
vim.keymap.set("i", "<M-k>", "<Up>", { noremap = true, silent = true, desc = "Move cursor up in insert mode" })
vim.keymap.set("i", "<M-j>", "<Down>", { desc = "Move cursor down in insert mode" })

-- Visual mode
vim.keymap.set("x", "S", function()
  require("mini.surround").add("visual")
end, { desc = "Add Surrounding in visual mode", silent = true })

-- Focus split
vim.keymap.set("n", "<leader>'", "<C-w>p", { desc = "Switch to the last visited split" })
vim.keymap.set("n", "<leader>1", "1<C-w>w", { desc = "Switch to split 1" })
vim.keymap.set("n", "<leader>2", "2<C-w>w", { desc = "Switch to split 2" })
vim.keymap.set("n", "<leader>3", "3<C-w>w", { desc = "Switch to split 3" })
vim.keymap.set("n", "<leader>4", "4<C-w>w", { desc = "Switch to split 4" })
vim.keymap.set("n", "<leader>5", "5<C-w>w", { desc = "Switch to split 5" })
vim.keymap.set("n", "<leader>6", "6<C-w>w", { desc = "Switch to split 6" })
vim.keymap.set("n", "<leader>7", "7<C-w>w", { desc = "Switch to split 7" })
vim.keymap.set("n", "<leader>8", "8<C-w>w", { desc = "Switch to split 8" })
vim.keymap.set("n", "<leader>9", "9<C-w>w", { desc = "Switch to split 9" })

-- Terminal
vim.keymap.set("t", "<M-t>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<C-Up>", "5<C-w>+", { desc = "Hide Terminal" })
vim.keymap.set(
  "n",
  "<C-w>t",
  "<cmd>vsplit term://bash<cr>i",
  { noremap = true, silent = true, desc = "Vertical split terminal" }
)

-- Buffers
vim.keymap.set("n", "<M-k>", "<cmd>BufferLineCycleNext<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<M-j>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Next Buffer" })

-- Registers
vim.keymap.set("n", "<C-h>", function()
  require("snacks").picker.registers()
end, { desc = "Registers" })
