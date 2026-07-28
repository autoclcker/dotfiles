return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
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
        "<leader>bd",
        false,
      },
      {
        "<leader>bl",
        false,
      },
      {
        "<leader>br",
        false,
      },
      {
        "<M-.>",
        "<Cmd>BufferLineMoveNext<CR>",
        desc = "Move buffer next",
      },
      {
        "<M-,>",
        "<Cmd>BufferLineMovePrev<CR>",
        desc = "Move buffer prev",
      },
      {
        "<leader>p",
        "<Cmd>BufferLineTogglePin<CR>",
        desc = "Toggle pin",
      },
      {
        "Z<",
        "<Cmd>BufferLineCloseLeft<CR>",
        desc = "Close Left buffers",
      },
      {
        "Z>",
        "<Cmd>BufferLineCloseRight<CR>",
        desc = "Close Right buffers",
      },
      {
        "ZB",
        function()
          Snacks.bufdelete()
        end,
        desc = "Close Buffer",
      },
    },
  },
}
