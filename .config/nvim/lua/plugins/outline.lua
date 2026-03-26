return {
  "hedyhli/outline.nvim",
  config = function()
    vim.keymap.set("n", "<BS>", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

    require("outline").setup({
      auto_close = true,
      outline_window = {
        auto_close = true,
        position = "left",
        width = 30,
      },
      keymaps = {
        show_help = "?",
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        peek_location = "o",
        goto_and_close = "<S-Cr>",
        restore_location = "<C-g>",
        hover_symbol = "<C-space>",
        toggle_preview = "s",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_toggle = "<Tab>",
        fold_toggle_all = "<S-T>",
        fold_all = "<C-h>",
        unfold_all = "R",
        fold_reset = "t",
        down_and_jump = "<C-j>",
        up_and_jump = "<C-k>",
      },
    })
  end,
}
