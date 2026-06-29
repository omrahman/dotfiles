-- Editor options (moved out of init.lua).
local opt = vim.opt

-- UI
opt.number = true            -- absolute line number on the cursor line
opt.relativenumber = true    -- relative numbers elsewhere (fast j/k motions)
opt.cursorline = true        -- highlight the current line
opt.signcolumn = "yes"       -- always show the sign column (no text shift)
opt.termguicolors = true     -- 24-bit color
opt.scrolloff = 8            -- keep 8 lines visible above/below the cursor
opt.wrap = false             -- don't soft-wrap long lines
opt.colorcolumn = "80,100"   -- guide rulers

-- Search
opt.ignorecase = true        -- case-insensitive search...
opt.smartcase = true         -- ...unless the query has a capital letter
opt.hlsearch = true          -- highlight matches
opt.incsearch = true         -- show matches as you type

-- Indentation (2-space soft tabs; tweak per your taste)
opt.expandtab = true         -- tabs -> spaces
opt.shiftwidth = 2           -- size of an indent
opt.tabstop = 2              -- a tab counts as 2 columns
opt.softtabstop = 2
opt.smartindent = true       -- language-aware autoindent

-- Files & history
opt.undofile = true          -- persistent undo across sessions
opt.swapfile = false
opt.backup = false

-- Windows & splits
opt.splitright = true        -- vertical splits open to the right
opt.splitbelow = true        -- horizontal splits open below

-- Behavior
opt.mouse = "a"              -- enable the mouse in all modes
opt.clipboard = "unnamedplus"-- use the system clipboard
opt.updatetime = 250         -- faster CursorHold / swap write
opt.timeoutlen = 400         -- mapped-sequence wait (ms)
opt.completeopt = "menuone,noselect"
