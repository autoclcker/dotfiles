return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "kevinhwang91/nvim-hlslens",
  },
  config = function()
    local colors = require("vscode.colors").get_colors()
    require("scrollbar").setup({
      handle = {
        blend = 85,
        color = colors.vscFront,
        highlight = "CursorColumn",
      },
      marks = {
        Cursor = {
          color = "#00fcd6",
        },
        Search = { color = "#009961", text = { "▬" } },
        Error = { color = colors.vscRed },
        Warn = { color = colors.vscYellowOrange },
        Info = { color = colors.vscYellow },
        Hint = { color = colors.vscBlue },
        Misc = { color = colors.vscPink },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        handle = true,
        search = true, -- Requires hlslens
      },
    })
  end,
}
