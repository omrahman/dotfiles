-- General keymaps (plugin keymaps live with their specs in lua/plugins/).
local map = vim.keymap.set

-- Clear search highlight with <Esc>
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Save / quit
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- Move between windows with Ctrl-h/j/k/l
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Keep the cursor centered when jumping half-pages / search results
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep selection after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
