return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "kevinhwang91/nvim-hlslens",
  },
  config = function()
    local colors = require("tokyonight.colors").setup()
    require("scrollbar").setup({
      handle = {
        blend = 0,
        color = colors.bg_highlight,
      },
      marks = {
        Search = { color = colors.orange },
        Error = { color = colors.error },
        Warn = { color = colors.warning },
        Info = { color = colors.info },
        Hint = { color = colors.hint },
        Misc = { color = colors.purple },
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
