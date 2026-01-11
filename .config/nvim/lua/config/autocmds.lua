-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_autocmd("ExitPre", {
  group = vim.api.nvim_create_augroup("Exit", { clear = true }),
  command = "set guicursor=a:ver25-blinkwait700-blinkon250-blinkoff250",
  desc = "Set cursor back to beam when leaving Neovim.",
})

vim.api.nvim_create_autocmd("TermEnter", {
  callback = function(ev)
    vim.keymap.set("t", "<M-l>", "<c-l>", { buffer = ev.buf, nowait = true })
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

vim.api.nvim_create_user_command("SudoWrite", function()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    vim.notify("E32: No file name", vim.log.levels.ERROR)
    return
  end
  local tmpfile = vim.fn.tempname()
  vim.cmd("write! " .. tmpfile)
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("Password: ")
  vim.fn.inputrestore()
  if password == "" then
    vim.notify("Invalid password, sudo aborted", vim.log.levels.WARN)
    return
  end
  -- Use sudo to move the file
  local cmd =
    string.format("sudo -p '' -S dd if=%s of=%s bs=1048576", vim.fn.shellescape(tmpfile), vim.fn.shellescape(filepath))
  local proc = vim.system({ "sh", "-c", string.format("echo %q | %s", password, cmd) }):wait()
  -- Handle result
  if proc.code == 0 then
    vim.bo.modified = false
    vim.cmd.checktime()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", true)
  else
    vim.notify(proc.stderr, vim.log.levels.ERROR)
  end

  vim.fn.delete(tmpfile)
end, { desc = "Sudo write current buffer" })
