return {
  "lewis6991/satellite.nvim",
  event = "VeryLazy",
  config = function()
    require("satellite").setup({
      current_only = false,
      winblend = 50,
      zindex = 40,
      excluded_filetypes = {},
      width = 3,
      handlers = {
        cursor = {
          enable = true,
          overlap = true,
          symbols = { "⎺", "⎻", "⎼", "⎽" },
        },
        search = {
          enable = true,
          signs = { "-", "=", "≡" },
        },
        diagnostic = {
          enable = true,
          signs = { "-", "=", "≡" },
          min_severity = vim.diagnostic.severity.HINT,
        },
        gitsigns = {
          enable = false,
        },
        marks = {
          enable = true,
          show_builtins = false, -- shows the builtin marks like [ ] < >
          key = "m",
        },
        quickfix = {
          signs = { "-", "=", "≡" },
          enable = true,
        },
      },
    })
  end,
}
