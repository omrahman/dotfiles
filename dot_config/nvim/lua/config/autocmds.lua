-- Autocommands.
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Briefly highlight text on yank.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

-- Trim trailing whitespace on save.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})
