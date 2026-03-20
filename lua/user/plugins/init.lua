require("lazy").setup({
  -- Color scheme
  { "EdenEast/nightfox.nvim",
    config = function() require("user.plugins.nightfox") end },

  -- Main plugins
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() require("user.plugins.treesitter") end },

  { "nvim-lualine/lualine.nvim",
    config = function() require("user.plugins.lualine") end },

  { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function() require("user.plugins.telescope") end },

  require("user.plugins.fff"),

  { "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function() require("user.plugins.indent-blankline") end },

  { "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = function() require("user.plugins.lsp_signature") end },

  -- Utilities
  "nvim-lua/plenary.nvim",

  -- Autocomplete
  { "hrsh7th/nvim-cmp",
    config = function() require("user.plugins.cmp") end },
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "windwp/nvim-autopairs",

  -- File manager
  { "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim"
    },
    config = function() require("user.plugins.neo-tree") end },

  -- LSP
  { "neovim/nvim-lspconfig",
    config = function() require("user.plugins.lsp") end },

  { "williamboman/mason.nvim",
    config = function() require("mason").setup() end },

  { "williamboman/mason-lspconfig.nvim",
    config = function() require("user.plugins.mason") end },

  -- Bufers
  { 'romgrk/barbar.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require("user.plugins.barbar") end },

  -- Terminal
  { "akinsho/toggleterm.nvim",
    config = function() require("user.plugins.toggleterm") end },

  -- Dashboard
  { 'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require("user.plugins.alpha") end },
})
