-- ~/.config/nvim/init.lua — managed by chezmoi
-- Modular config: editor settings in lua/config/, plugin specs in lua/plugins/.

-- Leader keys must be set before lazy.nvim loads (plugins use them in keymaps).
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Editor settings (no plugins required).
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- ===========================================================================
-- Bootstrap lazy.nvim (https://github.com/folke/lazy.nvim)
-- ===========================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load every spec file under lua/plugins/.
require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "tokyonight-night", "habamax" } },
  checker = { enabled = false },  -- don't auto-check for plugin updates
  change_detection = { notify = false },
})
