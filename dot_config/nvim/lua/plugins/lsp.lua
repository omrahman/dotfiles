-- LSP: mason installs servers, nvim-lspconfig ships their default configs,
-- and Neovim 0.11+'s native vim.lsp.config/enable wires them up.
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      if not (vim.lsp.config and vim.lsp.enable) then
        vim.notify("LSP config requires Neovim 0.11+", vim.log.levels.WARN)
        return
      end

      -- Install servers (add more names here, then to vim.lsp.enable below).
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },  -- e.g. "pyright", "ts_ls", "rust_analyzer"
      })

      -- Advertise nvim-cmp's completion capabilities to every server.
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Per-server tweaks: teach lua_ls about the `vim` global.
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      vim.lsp.enable({ "lua_ls" })  -- add server names here as you install them

      -- Buffer-local keymaps, set when a server attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(ev)
          local function m(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          m("gd", vim.lsp.buf.definition,     "Goto definition")
          m("gr", vim.lsp.buf.references,     "References")
          m("gi", vim.lsp.buf.implementation, "Goto implementation")
          m("K",  vim.lsp.buf.hover,          "Hover docs")
          m("<leader>rn", vim.lsp.buf.rename,      "Rename symbol")
          m("<leader>ca", vim.lsp.buf.code_action, "Code action")
          m("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          m("]d", function() vim.diagnostic.jump({ count =  1 }) end, "Next diagnostic")
        end,
      })
    end,
  },
}
