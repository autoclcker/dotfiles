return {
  "snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          layout = {
            preset = "sidebar",
            layout = { position = "right" },
          },
          win = {
            list = {
              keys = {
                ["."] = "toggle_hidden",
                ["o"] = "toggle_preview",
                ["v"] = "edit_vsplit",
                ["e"] = "confirm",
              },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>,",
      false,
    },
    {
      "<leader>:",
      false,
    },
    {
      "<leader>/",
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
      "<M-e>",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    {
      "<M-t>",
      function()
        Snacks.terminal()
      end,
      desc = "Open Terminal",
    },
    {
      "<leader>z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },
    {
      "<leader>Z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<C-g>",
      LazyVim.pick("grep"),
      desc = "Grep",
    },
    {
      "q/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "Search History",
    },
    {
      "q:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<C-m>",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      "<C-n>",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume last picker",
    },
    {
      "<leader>e",
      function()
        local explorer_pickers = Snacks.picker.get({ source = "explorer" })
        if #explorer_pickers == 0 then
          -- If no explorer picker is open, open a new one
          Snacks.picker.explorer()
        else
          -- If an explorer picker is open, focus it
          explorer_pickers[1]:focus()
        end
      end,
      { desc = "Snacks File Explorer" },
    },
  },
}
