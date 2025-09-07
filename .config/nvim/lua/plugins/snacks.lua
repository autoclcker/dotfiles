local keys = require("lazy.core.handler.keys")
return {
  "snacks.nvim",
  enabled = true,
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
      "<leader>,",
      false,
    },
    {
      "<leader>o",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<M-t>",
      function()
        Snacks.terminal()
      end,
      desc = "Show Terminal",
    },
    {
      "<C-g>",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "q:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },

    {
      "q/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "Search History",
    },
  },
}
