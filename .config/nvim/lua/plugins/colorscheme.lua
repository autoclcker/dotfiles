return {
  {
    "Mofiqul/vscode.nvim",
    config = function()
      local colors = require("vscode.colors").get_colors()
      require("vscode").setup({
        style = "dark",
        italic_inlayhints = true,
        underline_links = true,
        group_overrides = {
          Cursor = { fg = "#00fcd6", bg = colors.vscCursorLight },
          CursorLineNr = { fg = "#00fcd6", bg = colors.vscBack },
          Comment = { fg = colors.vscLineNumber, bg = "NONE", italic = true },
          SnacksPickerBorder = { fg = "#009961", bg = colors.vscBack },
        },
      })
      require("bufferline").setup({
        highlights = {
          fill = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "StatusLineNC" },
          },
          background = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          buffer_visible = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          buffer_selected = {
            fg = { attribute = "fg", highlight = "CursorLineNr" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          separator = {
            fg = { attribute = "bg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "StatusLine" },
          },
          separator_selected = {
            fg = { attribute = "fg", highlight = "Special" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
          separator_visible = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "StatusLineNC" },
          },
          close_button = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
          },
        },
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
