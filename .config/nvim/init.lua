-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- [[ Setting options ]]

vim.o.relativenumber = true
vim.o.number = true
vim.o.mouse = 'a'

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- set statusline background and foreground color
vim.cmd ':hi statusline guibg=none'
vim.cmd ':hi statusline guifg=gray'

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
-- vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 15

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

-- vim fold with treesitter
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldtext = ""
vim.o.foldenable = false

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
map("n", "gl", "$", { desc = "Go to end of line" })
map("n", "gh", "^", { desc = "Go to start of line" })

-- Better paste
map("v", "p", '"_dP', opts)

-- Better indenting - stay in visual mode when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

map('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })

    vim.keymap.set({ 'x', 'o' }, 'v', function()
      if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require 'vim.treesitter._select'.select_parent(vim.v.count1)
      else
        vim.lsp.buf.selection_range(vim.v.count1)
      end
    end, { desc = 'Select parent (outer) node' })

    vim.keymap.set({ 'x', 'o' }, 'V', function()
      if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require 'vim.treesitter._select'.select_child(vim.v.count1)
      else
        vim.lsp.buf.selection_range(-vim.v.count1)
      end
    end, { desc = 'Select child (inner) node' })


-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

--- [[ Configure and install plugins ]]
vim.pack.add {
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-flutter/flutter-tools.nvim',
  'https://github.com/supermaven-inc/supermaven-nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/tridactyl/vim-tridactyl',
  'https://github.com/lervag/vimtex',
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/EdenEast/nightfox.nvim',
  -- 'https://github.com/aspeddro/gitui.nvim',
}


-- Telescope
require('telescope').setup {}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
map('n', '<leader><leader>', builtin.find_files, { desc = '[S]earch [F]iles' })
map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
map('n', '<leader>/', builtin.live_grep, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Shortcut for searching your Neovim configuration files
map('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

-- [[ Configure and install plugins ]]
require('flutter-tools').setup({})
require('supermaven-nvim').setup({
  keymaps = {
    accept_suggestion = "<Tab>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-j>",
  },
})

require('oil').setup()

require('blink.cmp').setup{
      keymap = {
        preset = 'default',
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        trigger = { prefetch_on_insert = false },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'rust', prebuilt_binaries = { force_version = 'v1.9.1' } },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
}

require('nvim-treesitter').setup {
  ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },
}

require('mini.surround').setup()
require('mini.pairs').setup()
require('mini.icons').setup()
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}
-- require('supermaven-nvim').setup()

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup {
  ensure_installed = {
    'lua_ls',
    'stylua',
  },
}

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {
          'vim',
          'require',
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
    },
  },
})

vim.cmd 'packadd nvim.undotree'
map('n', '<leader>u', require('undotree').open)

-- set colorscheme
vim.cmd.colorscheme('carbonfox')
