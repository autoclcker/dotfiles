return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      win = {
        keys = {
          nav_h = false,
          nav_j = false,
          nav_k = false,
          nav_l = false,
        },
      },
    },
    picker = {
      win = {
        input = {
          keys = {
            ["<M-r>"] = false,
            ["<C-down>"] = { "focus_list", mode = { "i", "n" } },
            ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<C-o>"] = { "toggle_regex", mode = { "i", "n" } },
            ["<Esc>"] = { "close", mode = { "i", "n" } },
            ["<Tab>"] = { "inspect", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["e"] = "confirm",
            ["v"] = "edit_vsplit",
          },
        },
      },
      sources = {
        explorer = {
          enabled = true,
          hidden = true,
          replace_netrw = true,
          actions = {
            open_terminal = function(picker)
              local item = picker:current()
              if not (item and item.file) then
                return
              end
              local dir = item.dir and item.file or vim.fs.dirname(item.file)
              Snacks.terminal.open(nil, { cwd = dir, auto_insert = true })
            end,
          },
          layout = {
            preset = "sidebar",
            layout = { position = "right" },
          },
          win = {
            input = {
              keys = {
                ["<C-c>"] = { "focus_list", mode = "i" },
                ["<Esc>"] = { "focus_list", mode = "i" },
              },
            },
            list = {
              keys = {
                ["<C-j>"] = false,
                ["<C-k>"] = false,
                ["<M-d>"] = false,
                ["<M-h>"] = false,
                ["<M-i>"] = false,
                ["<M-m>"] = false,
                ["<M-p>"] = false,
                ["<M-w>"] = false,
                ["<S-Tab>"] = false,
                ["H"] = false,
                ["I"] = false,
                ["m"] = false,
                ["P"] = false,
                ["Z"] = false,
                ["."] = "toggle_hidden",
                ["["] = "explorer_up",
                ["]"] = "explorer_focus",
                ["<BS>"] = "toggle_ignored",
                ["<C-h>"] = "explorer_close_all",
                ["<S-Down>"] = "select_and_next",
                ["<S-Up>"] = "select_and_prev",
                ["<Tab>"] = "Inspect",
                ["o"] = "toggle_preview",
                ["t"] = "open_terminal",
                ["x"] = "explorer_move",
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
      "<M-o>",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "File git history",
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
        local terms = Snacks.terminal.list()
        if #terms > 0 then
          for _, term in ipairs(terms) do
            term:toggle()
          end
        else
          Snacks.terminal.open(nil, { auto_insert = true })
        end
      end,
      desc = "Toggle Terminal",
    },
    {
      "<F5>",
      mode = { "n" },
      function()
        Snacks.terminal.open(vim.opt.shell:get(), nil)
      end,
      desc = "Floating Terminal",
    },
    {
      "<C-v>",
      mode = { "t" },
      function()
        Snacks.terminal.open(nil, { auto_insert = true, count = #Snacks.terminal.list() + 1 })
      end,
      desc = "Open Split Terminal",
    },
    {
      "<leader>t",
      function()
        Snacks.terminal.open(nil, { cwd = vim.fn.expand("%:p:h"), auto_insert = true })
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
      "<C-CR>",
      mode = { "n", "i", "v" },
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
      mode = { "n", "v" },
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
          Snacks.picker.explorer()
        else
          explorer_pickers[1]:focus()
        end
      end,
      { desc = "Snacks File Explorer" },
    },
  },
}
