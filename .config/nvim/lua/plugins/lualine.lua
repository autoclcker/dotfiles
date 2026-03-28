return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local auto = require("lualine.themes.auto")
    local icons = LazyVim.config.icons
    local lualine_modes = { "insert", "normal", "visual", "command", "replace", "inactive", "terminal" }
    for _, field in ipairs(lualine_modes) do
      if auto[field] and auto[field].c then
        auto[field].c.bg = "#181818"
      end
    end

    local opts = {
      options = {
        theme = auto,
        always_divide_middle = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      winbar = {
        lualine_a = {
          {
            LazyVim.lualine.pretty_path(),
            color = "StatusLine",
          },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          {
            "branch",
            color = { fg = "#00ffa6", bg = "#000000", gui = "bold" },
            separator = { right = "" },
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
            separator = { right = "" },
            color = { fg = "#11fc00", bg = "#000000" },
          },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              hint = icons.diagnostics.Hint,
              info = icons.diagnostics.Info,
              warn = icons.diagnostics.Warn,
            },

            diagnostics_color = {
              error = { fg = "#ff0000", bg = "#13261c" },
              hint = { bg = "#13261c" },
              info = { fg = "#ffffff", bg = "#13261c" },
              warn = { fg = "#fbff00", bg = "#13261c" },
            },
            separator = { right = "" },
          },
        },
        lualine_x = {
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = function()
              return { fg = Snacks.util.color("Statement"), bg = "#181818" }
            end,
          },
          {
            "filetype",
            color = { fg = "#11fc00", bg = "#181818", bold = true },
          },
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function()
              return { fg = Snacks.util.color("Constant") }
            end,
          },
        },
        lualine_y = {
          {
            "progress",
            color = { fg = "#00ffa6", bg = "#000000" },
          },
        },
        lualine_z = {
          {
            "location",
            color = { fg = "#000000", bg = "#00afff" },
          },
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:StatusLine}",
        hl_group = "StatusLine",
      })
      table.insert(opts.winbar.lualine_a, {
        symbols.get,
        cond = symbols.has,
      })
    end

    return opts
  end,
}
