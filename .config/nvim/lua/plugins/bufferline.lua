return {
  {
    "akinsho/bufferline.nvim",
    keys = {
      {
        "]b",
        "<Cmd>BufferLineMoveNext<CR>",
        { desc = "Move buffer next" },
      },
      {
        "[b",
        "<Cmd>BufferLineMovePrev<CR>",
        { desc = "Move buffer prev" },
      },
      {
        "<leader>p",
        "<Cmd>BufferLineTogglePin<CR>",
        desc = "Toggle pin",
      },
      {
        "]]",
        "<Cmd>BufferLineCycleNext<CR>",
        desc = "Prev Buffer",
      },
      {
        "[[",
        "<Cmd>BufferLineCyclePrev<CR>",
        desc = "Next Buffer",
      },
      {
        "ZB",
        function()
          Snacks.bufdelete()
        end,
        { desc = "Delete Buffer" },
      },
    },
  },
}
