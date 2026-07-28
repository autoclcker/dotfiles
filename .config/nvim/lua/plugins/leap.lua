return {
  url = "https://codeberg.org/andyg/leap.nvim",
  event = "VeryLazy",
  enabled = true,
  keys = false,
  config = function(_, _)
    vim.keymap.set({ "n" }, "s", "<Plug>(leap-forward)", { desc = "After cursor" })
    vim.keymap.set({ "n" }, "S", "<Plug>(leap-backward)", { desc = "Before cursor" })
    vim.keymap.set({ "n", "x" }, "gS", "<Plug>(leap-anywhere)", { desc = "All windows" })
    vim.keymap.set({ "o" }, "z", "<Plug>(leap-forward)", { desc = "leap-forward" })
    vim.keymap.set({ "o" }, "Z", "<Plug>(leap-backward)", { desc = "leap-backward" })
  end,
}
