require 'options'
require 'keymaps'
require 'autocmds'

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
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/EdenEast/nightfox.nvim',
  { src = 'https://github.com/3rd/image.nvim', data = { build = false } },
  'https://github.com/m4xshen/smartcolumn.nvim',
  'https://github.com/lommix/godot.nvim',
}

require('godot').setup {

  -- Path to your Godot executable
  bin = 'godot',

  -- DAP configuration
  dap = {
    host = '127.0.0.1',
    port = 6006,
  },

  -- GUI settings for console (passed to nvim_open_win)
  gui = {
    console_config = {
      anchor = 'SW',
      border = 'double',
      col = 1,
      height = 10,
      relative = 'editor',
      row = 99999,
      style = 'minimal',
      width = 99999,
    },
  },

  -- Expose user commands automatically (optional)
  expose_commands = true,
}

require('smartcolumn').setup()

require('image').setup {
  processor = 'magick_cli',
}

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    gdscript = { 'gdscript-formatter' },
    flutter = { 'dart_format' },
    -- Conform can also run multiple formatters sequentially
    -- python = { "isort", "black" },
    --
    -- You can use 'stop_after_first' to run the first available formatter from
    -- the list
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
  },
}

-- Telescope
require('telescope').setup {}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')

local map = vim.keymap.set
-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
map('n', '<leader><leader>', builtin.find_files, { desc = '[S]earch [F]iles' })
map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect' })
map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch curr [W]ord' })
map('n', '<leader>/', builtin.live_grep, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostic' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

-- [[ Configure and install plugins ]]
require('flutter-tools').setup {}
require('supermaven-nvim').setup {
  keymaps = {
    accept_suggestion = '<Tab>',
    clear_suggestion = '<C-]>',
    accept_word = '<C-j>',
  },
}

require('blink.cmp').setup {
  keymap = {
    preset = 'default',
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show documentation after a delay.
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
  fuzzy = {
    implementation = 'rust',
    prebuilt_binaries = { force_version = 'v1.9.1' },
  },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}

require('nvim-treesitter').setup {
  ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'markdown' },
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby)
    -- for indent rules. If you are experiencing weird indenting issues, add
    -- the language to the list of additional_vim_regex_highlighting and
    -- disabled languages for indent.
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },
}

require('mini.surround').setup()
require('mini.pairs').setup()
require('mini.icons').setup()
require('mini.ai').setup()
require('mini.files').setup()

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
require 'lsp-config'

vim.cmd 'packadd nvim.undotree'
vim.keymap.set('n', '<leader>u', require('undotree').open)

-- set colorscheme
vim.cmd.colorscheme 'carbonfox'
