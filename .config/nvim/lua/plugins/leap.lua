return {
  "ggandor/leap.nvim",
  enabled = true,
  keys = false,
  config = function(_, _)
    local leap = require("leap")
    vim.keymap.set({ "n", "x" }, "s", "<Plug>(leap-forward-to)", { desc = "leap-forward-to" })
    vim.keymap.set({ "n", "x" }, "S", "<Plug>(leap-backward-to)", { desc = "leap-backward-to" })
    vim.keymap.set({ "o" }, "z", "<Plug>(leap-forward-to)", { desc = "leap-forward-to" })
    vim.keymap.set({ "o" }, "Z", "<Plug>(leap-backward-to)", { desc = "leap-backward-to" })
  end,
}
