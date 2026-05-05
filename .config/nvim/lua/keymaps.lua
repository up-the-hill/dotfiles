-- [[ BASIC KEYMAPS ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- switch to last buffer with leader s
map('n', '<leader>s', '<cmd>b#<CR>')

-- open netrw with leader e
map('n', '<leader>e', '<cmd>e .<CR>')

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- this opens a little floating window
map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- this shows a nice navagatable list with all the errors
map('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- keymaps for moving around
map('n', 'gl', '$', { desc = 'Go to end of line' })
map('n', 'gh', '^', { desc = 'Go to start of line' })

-- Better paste
map('v', 'p', '"_dP', opts)

-- Better indenting - stay in visual mode when indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

map('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })

vim.keymap.set({ 'x', 'o' }, 'v', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require('vim.treesitter._select').select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = 'Select parent (outer) node' })

vim.keymap.set({ 'x', 'o' }, 'V', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require('vim.treesitter._select').select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = 'Select child (inner) node' })

-- Better up/down movement
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
