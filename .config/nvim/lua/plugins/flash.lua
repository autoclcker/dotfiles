return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    {
      "s",
      false,
    },
    {
      "S",
      false,
    },
    {
      "r",
      false,
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
