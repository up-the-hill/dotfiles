-- Guide to configuring lsp configs:
-- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

return {
  "neovim/nvim-lspconfig",

  config = function()
    lspconfig.emmet_language_server.setup({
      filetypes = {
        "css",
        "eruby",
        "html",
        "javascript",
        "javascriptreact",
        "less",
        "sass",
        "scss",
        "pug",
        "typescriptreact",
        "astro",
      },
    })

    lspconfig.cssls.setup({
      filetypes = {
        "css",
        "scss",
        "less",
        "astro",
      },
    })

    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      init_options = { hostInfo = "neovim" },
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
      single_file_support = true,
    })
  end,
}
