# dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io).
Targets **macOS (zsh)** and **Windows (PowerShell)** from a single source repo.

## What's here

| Source file                                             | Deploys to                                      | OS      |
| ------------------------------------------------------- | ----------------------------------------------- | ------- |
| `dot_zshrc.tmpl`                                        | `~/.zshrc`                                       | macOS   |
| `dot_gitconfig.tmpl`                                    | `~/.gitconfig`                                   | both    |
| `dot_config/nvim/init.lua`                              | `~/.config/nvim/init.lua`                        | both    |
| `Documents/PowerShell/Microsoft.PowerShell_profile.ps1` | `%USERPROFILE%\Documents\PowerShell\…profile.ps1` | Windows |
| `run_once_install-homebrew-packages.sh.tmpl`            | _runs on `apply`_ (installs Homebrew + packages) | macOS   |

On Windows, the PowerShell profile sets `XDG_CONFIG_HOME=~/.config` so Neovim
reads the same `~/.config/nvim/init.lua` as macOS — one config, both OSes.

chezmoi naming conventions: `dot_` → `.`, the `.tmpl` suffix marks a
[template](https://www.chezmoi.io/user-guide/templating/). Which files land on
which OS is controlled by [`.chezmoiignore`](.chezmoiignore).

## Set up on a new machine

### macOS

```sh
# 1. Install chezmoi
brew install chezmoi

# 2. Pull this repo and apply it (prompts once for your git name/email)
chezmoi init --apply https://github.com/omrahman/dotfiles.git
```

### Windows (PowerShell)

```powershell
# 1. Install chezmoi
winget install twpayne.chezmoi

# 2. Pull this repo and apply it (prompts once for your git name/email)
chezmoi init --apply https://github.com/omrahman/dotfiles.git
```

`chezmoi init --apply` clones the repo into chezmoi's source directory, prompts
for your identity via [`.chezmoi.toml.tmpl`](.chezmoi.toml.tmpl), and writes the
files into place.

> This machine instead points chezmoi at `~/repos/dotfiles` as its source via
> `sourceDir` in `~/.config/chezmoi/chezmoi.toml` (that config is local and not
> committed).

## Daily workflow

```sh
chezmoi edit ~/.zshrc     # edit the source of a managed file
chezmoi diff              # preview pending changes
chezmoi apply             # write changes into $HOME
chezmoi add ~/.foorc      # start managing a new file
chezmoi cd                # drop into the source repo to commit & push
```

## Scripts (`run_once_` / `run_onchange_`)

chezmoi runs scripts during `apply`. `run_once_install-homebrew-packages.sh.tmpl`
installs Homebrew (if missing) and a list of packages via `brew bundle`. It's
templated to render empty on non-macOS machines, so it's a no-op on Windows.

- Edit the inline Brewfile in the script to change what gets installed.
- `run_once_` re-runs whenever the script's content changes (tracked by hash).
- To run files but skip scripts: `chezmoi apply --exclude=scripts`.
- To preview what a script would do: `chezmoi cat-config` / `chezmoi execute-template < <file>`.

## Neovim

`dot_config/nvim/` is a modular [lazy.nvim](https://github.com/folke/lazy.nvim)
setup. lazy.nvim bootstraps itself on first launch, then installs everything.

```
nvim/
├── init.lua                 # leader keys, bootstrap lazy, load modules
├── lua/config/              # options.lua, keymaps.lua, autocmds.lua
└── lua/plugins/             # one file per plugin (auto-imported)
    ├── colorscheme.lua      # tokyonight
    ├── treesitter.lua       # syntax highlighting/indent (auto-installs parsers)
    ├── telescope.lua        # fuzzy finder (fzf-native sorter, ripgrep live-grep)
    ├── lsp.lua              # mason + native vim.lsp.config/enable (lua_ls default)
    └── completion.lua       # nvim-cmp + LuaSnip
```

**First launch:** open `nvim`, let lazy install plugins, then `:Mason` shows the
LSP server manager. The `lua_ls` server installs automatically; add more by
editing `ensure_installed` and `vim.lsp.enable(...)` in `lua/plugins/lsp.lua`
(e.g. `pyright`, `ts_ls` — those need Node, which the Brewfile can install).

**Key plugin maps** (leader = `Space`):

| Keys           | Action                  |
| -------------- | ----------------------- |
| `<leader>ff`   | Find files (Telescope)  |
| `<leader>fg`   | Live grep               |
| `<leader>fb`   | Buffers                 |
| `gd` / `gr`    | LSP definition / refs   |
| `K`            | LSP hover docs          |
| `<leader>ca`   | LSP code action         |
| `<leader>rn`   | LSP rename              |

> Treesitter parsers and the `fzf-native` sorter compile on install, so a new
> machine needs a C compiler (`cc`/`make`) and `git` — present by default on
> macOS with Xcode CLT, and on Windows via the LSP/build tooling.

## Machine-local overrides (untracked)

For secrets or per-machine tweaks you don't want in the repo:

- zsh → `~/.zshrc.local`
- PowerShell → `Documents/PowerShell/profile.local.ps1`

Both are sourced automatically if present.
