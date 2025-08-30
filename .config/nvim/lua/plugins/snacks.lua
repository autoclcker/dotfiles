return {
  "snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          layout = { preset = "sidebar", layout = { position = "right" } },
        },
      },
    },
  },
  keys = {
    {
      "<leader>Z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },
    {
      "<M-t>",
      function()
        Snacks.terminal()
      end,
      desc = "Show Terminal",
    },
  },
}
