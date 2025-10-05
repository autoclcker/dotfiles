return {
  {
    "akinsho/bufferline.nvim",
    keys = {
      {
        "]B",
        false,
      },
      {
        "[B",
        false,
      },
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
        "ZB",
        function()
          Snacks.bufdelete()
        end,
        { desc = "Delete Buffer" },
      },
    },
  },
}
