require 'options'
require 'keymaps'
require 'autocmds'

-- Load .env file
local env_file = vim.fn.stdpath 'config' .. '/.env'
if vim.fn.filereadable(env_file) == 1 then
  for line in io.lines(env_file) do
    local key, value = line:match '^%s*([%w_]+)%s*=%s*(.-)%s*$'
    if key and value then
      vim.env[key] = value
    end
  end
end

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
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/EdenEast/nightfox.nvim',
  { src = 'https://github.com/3rd/image.nvim', data = { build = false } },
  'https://github.com/m4xshen/smartcolumn.nvim',
  -- 'https://github.com/lommix/godot.nvim',
  -- 'https://github.com/OXY2DEV/markview.nvim',
  'https://github.com/arakkkkk/kanban.nvim',
  'https://github.com/milanglacier/minuet-ai.nvim',
  'https://github.com/supermaven-inc/supermaven-nvim',
  'https://github.com/folke/tokyonight.nvim',
}

-- require('minuet').setup {
--   virtualtext = {
--     auto_trigger_ft = {},
--     keymap = {
--       -- accept whole completion
--       accept = '<Tab>',
--       -- accept one line
--       accept_line = '<A-a>',
--       -- accept n lines (prompts for number)
--       -- e.g. "A-z 2 CR" will accept 2 lines
--       accept_n_lines = '<A-z>',
--       -- Cycle to prev completion item, or manually invoke completion
--       prev = '<A-[>',
--       -- Cycle to next completion item, or manually invoke completion
--       next = '<A-]>',
--       dismiss = '<A-e>',
--     },
--   },
--
--   provider = 'openai_compatible',
--   request_timeout = 3.5,
--   throttle = 1500, -- Increase to reduce costs and avoid rate limits
--   debounce = 600, -- Increase to reduce costs and avoid rate limits
--   provider_options = {
--     openai_compatible = {
--       api_key = 'OPENROUTER_API_KEY',
--       end_point = 'https://openrouter.ai/api/v1/chat/completions',
--       model = 'openrouter/free',
--       -- model = 'deepseek/deepseek-v4-flash',
--       name = 'Openrouter',
--       optional = {
--         -- max_tokens = 56,
--         -- top_p = 0.9,
--         provider = {
--           -- Prioritize throughput for faster completion
--           sort = 'throughput',
--         },
--         -- disable thinking to avoid first token latency
--         reasoning_effort = 'none',
--       },
--     },
--   },
-- }

require('kanban').setup {}
vim.keymap.set('n', '<leader>k', ':KanbanOpen kanban.md<CR>')

-- require('godot').setup {
--   -- Path to your Godot executable
--   bin = 'godot',
--
--   -- DAP configuration
--   dap = {
--     host = '127.0.0.1',
--     port = 6006,
--   },
--
--   -- GUI settings for console (passed to nvim_open_win)
--   gui = {
--     console_config = {
--       anchor = 'SW',
--       border = 'double',
--       col = 1,
--       height = 10,
--       relative = 'editor',
--       row = 99999,
--       style = 'minimal',
--       width = 99999,
--     },
--   },
--
--   -- Expose user commands automatically (optional)
--   expose_commands = true,
-- }

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
  ensure_installed = { 'bash', 'c', 'diff', 'html', 'css', 'tailwindcss', 'lua', 'markdown', 'python', 'javascript', 'typescript', 'json', 'go', 'rust', 'c' },
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'ink', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'tsx', 'jsx' },
  callback = function()
    vim.treesitter.start()
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').ink = {
      install_info = {
        url = 'https://github.com/little-bonsai/tree-sitter-ink',
        -- revision = <sha>, -- commit hash for revision to check out; HEAD if missing
        -- optional entries:
        -- branch = 'develop', -- only needed if different from default branch
        -- location = 'parser', -- only needed if the parser is in subdirectory of a "monorepo"
        generate = true, -- only needed if repo does not contain pre-generated `src/parser.c`
        -- generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
        queries = 'queries', -- also install queries from given directory
      },
    }
  end,
})

vim.filetype.add {
  extension = {
    ink = 'ink',
  },
}

vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').lua.install_info.generate = true
  end,
})

require('mini.surround').setup()
require('mini.pairs').setup()
require('mini.icons').setup()
require('mini.ai').setup()
require('mini.files').setup {
  options = {
    permanent_delete = false,
  },
}

vim.keymap.set('n', '<leader>e', function()
  MiniFiles.open(vim.api.nvim_buf_get_name(0), false)

  MiniFiles.reveal_cwd()
end)

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
    -- Lua
    'lua_ls',
    'stylua',
    -- Python
    'pyright',
    'ruff',
    -- Typescript
    'ts_ls',
    'biome', -- js linting / formatting, faster than eslint / prettier
    'jsonls',
    'html',
    'cssls',
    'tailwindcss',
    -- Go
    'gopls',
    'gofumpt',
    -- Rust
    'rust_analyzer',
    -- C
    'clangd',
  },
}
require 'lsp-config'

vim.cmd 'packadd nvim.undotree'
vim.keymap.set('n', '<leader>u', require('undotree').open)

-- set colorscheme
vim.cmd.colorscheme 'carbonfox'
