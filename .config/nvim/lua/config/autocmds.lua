-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_autocmd("ExitPre", {
  group = vim.api.nvim_create_augroup("Exit", { clear = true }),
  command = "set guicursor=a:ver25-blinkwait700-blinkon250-blinkoff250",
  desc = "Set cursor back to beam when leaving Neovim.",
})

vim.api.nvim_create_autocmd("TermEnter", {
  callback = function(ev)
    vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = ev.buf, nowait = true })
  end,
})

vim.api.nvim_create_autocmd("TermEnter", {
  callback = function(ev)
    vim.keymap.set("t", "<C-s>", "<C-\\><C-n>", { buffer = ev.buf, nowait = true })
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Set terminal to insert mode",
  callback = function()
    vim.schedule(function()
      vim.cmd(":startinsert")
    end)
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("snacks_explorer_autorefresh", { clear = true }),
  callback = function(event)
    local picker = Snacks.picker.get({ source = "explorer" })[1]
    if not picker or picker:cwd() == LazyVim.root() then
      return
    end
    local A = require("snacks.explorer.actions")
    pcall(function()
      picker:set_cwd(vim.fn.expand("%:p:h"))
      A.actions.explorer_update(picker)
    end)
  end,
})
