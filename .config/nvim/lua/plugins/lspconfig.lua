return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "mason.nvim",
    { "mason-org/mason-lspconfig.nvim", config = function() end },
  },
  opts = {
    inlay_hints = {
      enabled = false,
    },
    servers = {
      ["*"] = {
        keys = {
          { "gr", false },
          { "gI", false },
          {
            "gs",
            function()
              Snacks.picker.lsp_references()
            end,
            nowait = true,
            desc = "Go to References",
          },
          {
            "gk",
            function()
              Snacks.picker.lsp_type_definitions()
            end,
            desc = "Goto T[y]pe Definition",
          },
          {
            "gd",
            function()
              Snacks.picker.lsp_definitions()
            end,
            desc = "Goto Definition",
            has = "definition",
          },
          {
            "gl",
            function()
              Snacks.picker.lsp_implementations()
            end,
            desc = "Goto Implementation",
          },
        },
      },
    },
  },
}
