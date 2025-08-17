return {
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  -- {
  --   "m4xshen/hardtime.nvim",
  --   lazy = false,
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --   opts = {},
  -- },
  {
    "tridactyl/vim-tridactyl",
  },
  {
    "tidalcycles/vim-tidal",
    config = function()
      vim.g.tidal_target = "terminal"
    end,
  },
}
