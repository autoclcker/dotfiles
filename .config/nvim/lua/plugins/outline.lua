return {
  "hedyhli/outline.nvim",
  config = function()
    vim.keymap.set("n", "<BS>", "<cmd>OutlineOpen<CR>", { desc = "Open Outline" })
    require("outline").setup({
      preview_window = {
        auto_preview = true,
        live = true,
      },
      outline_window = {
        auto_close = true,
        auto_width = {
          enabled = false,
        },
        floating = true,
        position = "left",
      },
      keymaps = {
        show_help = "?",
        close = { "<Esc>", "<C-c>" },
        goto_location = "<CR>",
        peek_location = "o",
        goto_and_close = "<S-Cr>",
        restore_location = "<BS>",
        hover_symbol = "<Tab>",
        toggle_preview = "e",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_toggle = "<space>",
        fold_toggle_all = "<S-T>",
        fold_all = "<C-h>",
        unfold_all = "U",
        fold_reset = "t",
        down_and_jump = "J",
        up_and_jump = "K",
      },
    })
  end,
}
