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
        "<leader>.",
        "<Cmd>BufferLineMoveNext<CR>",
        { desc = "Move buffer next" },
      },
      {
        "<leader>,",
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
