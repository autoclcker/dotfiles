return {
  {
    "Mofiqul/vscode.nvim",
    config = function()
      local colors = require("vscode.colors").get_colors()
      local black = "#000000"
      local white = "#ffffff"
      local vscDefaultDark = "#181818"
      local vscGreenBorder = "#009961"
      require("vscode").setup({
        style = "dark",
        italic_inlayhints = true,
        transparent = false,
        underline_links = true,
        group_overrides = {
          BufferLineFill = { fg = vscGreenBorder, bg = vscDefaultDark },
          Comment = { fg = colors.vscLineNumber, bg = "NONE", italic = true },
          Cursor = { fg = "#00fcd6", bg = colors.vscCursorLight },
          CursorLineNr = { fg = "#00fcd6", bg = colors.vscBack },
          SnacksPickerBorder = { fg = vscGreenBorder, bg = colors.vscBack },
          StatusLine = { fg = colors.vscCursorLight, bg = colors.vscBack, italic = true },
          StatusLineNC = { fg = colors.vscFront, bg = vscDefaultDark },
          VertSplit = { fg = vscGreenBorder, bg = colors.vscBack },
          NormalFloat = { fg = white, bg = black },
          WhichKeyValue = { fg = colors.vscFront, bg = black },
          WhichKeyBorder = { fg = vscGreenBorder, bg = black },
          WhichKeyTitle = { fg = colors.vscFront, bg = black },
          SatelliteCursor = { fg = "#00fcd6" },
          SatelliteBar = { bg = "#666666" },
        },
      })
      require("bufferline").setup({
        highlights = {
          background = {
            fg = colors.vscCursorLight,
            bg = { attribute = "bg", highlight = "BufferLineFill" },
          },
          buffer_visible = {
            fg = colors.vscCursorLight,
            bg = colors.vscBack,
          },
          buffer_selected = {
            fg = white,
            bg = colors.vscPopupBack,
          },
          separator = {
            fg = { attribute = "fg", highlight = "VertSplit" },
            bg = { attribute = "bg", highlight = "BufferLineFill" },
          },
          close_button = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "BufferLineFill" },
          },
        },
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
  {
    "catppuccin/nvim",
    enabled = false,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
