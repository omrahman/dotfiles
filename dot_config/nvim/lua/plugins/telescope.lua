-- Telescope: fuzzy finder for files, grep, buffers, help, diagnostics.
-- live_grep uses ripgrep (rg), installed via the Homebrew bootstrap script.
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        -- Native C sorter — much faster. Only build it where `make` exists;
        -- otherwise Telescope falls back to its pure-Lua sorter.
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",   desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help tags" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>",desc = "Diagnostics" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({})
      pcall(telescope.load_extension, "fzf")  -- no-op if fzf-native isn't built
    end,
  },
}
