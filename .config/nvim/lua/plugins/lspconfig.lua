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
      clangd = {
        keys = {
          { "<BS>", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        },
        root_markers = {
          "compile_commands.json",
          "compile_flags.txt",
          "configure.ac", -- AutoTools
          "Makefile",
          "configure.ac",
          "configure.in",
          "config.h.in",
          "meson.build",
          "meson_options.txt",
          "build.ninja",
          ".git",
        },
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      },
    },
  },
}
