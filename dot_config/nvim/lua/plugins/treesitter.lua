-- Treesitter: syntax-aware highlighting & indentation.
-- Pinned to the `master` branch for the stable `.configs` setup API.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash", "json", "yaml", "toml",
        "markdown", "markdown_inline", "python",
        "javascript", "typescript", "tsx",
      },
      auto_install = true,          -- install missing parsers on entering a buffer
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
