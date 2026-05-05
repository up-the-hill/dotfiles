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
    Gdscript = {
      filetypes = {
        'gdscript',
        'gd',
      },
      root_dir = function(fname)
        return vim.fn.fnamemodify(fname, ':h')
      end,
      globals = {
        'godot',
        'preload',
        'preload_modules',
        'preload_singletons',
        'preload_classes',
      },
    },
  },
})
