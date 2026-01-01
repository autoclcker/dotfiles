return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
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
      mode = { "n", "t" },
      function()
        Snacks.terminal.toggle(nil, { auto_insert = true })
      end,
      desc = "Toggle Terminal",
    },
    {
      "<leader>T",
      mode = { "n" },
      function()
        Snacks.terminal.open("/bin/bash", nil)
      end,
      desc = "Floating Terminal",
    },
    {
      "<C-v>",
      mode = { "t" },
      function()
        Snacks.terminal.open(nil, { auto_insert = true })
      end,
      desc = "Open Split Terminal",
    },
    {
      "<leader>t",
      function()
        Snacks.terminal(nil, { cwd = vim.fn.expand("%:p:h"), auto_insert = true })
      end,
      desc = "Open Terminal in fileDir",
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
