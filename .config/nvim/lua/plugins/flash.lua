return {
  "folke/flash.nvim",
  event = "VeryLazy",
  enabled = true,
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      false,
    },
    {
      "S",
      mode = { "n", "x", "o" },
      false,
    },
    {
      "r",
      mode = { "n", "x", "o" },
      false,
    },
    {
      "<M-f>",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "<Home>",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          search = { forward = false, wrap = false, multi_window = false },
        })
      end,
      desc = "Backward search only",
    },
    {
      "<End>",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          search = { forward = true, wrap = false, multi_window = false },
        })
      end,
      desc = "Forward search only",
    },
  },
}
