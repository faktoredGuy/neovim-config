--- ===== LAZY.NVIM SETUP ===== ---
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local git_command = string.format(
    '/bin/sh -c "git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable %s"',
    lazypath
  )
  vim.fn.system(git_command)
end
vim.opt.rtp:prepend(lazypath)

-- ===== PLUGINS =====
require("lazy").setup({
  -- ===== CORE PLUGINS =====
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-lualine/lualine.nvim",
  { "nvim-telescope/telescope.nvim",   tag = "0.1.8",      dependencies = { "nvim-lua/plenary.nvim" } },
  
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      local highlight = {
        "IblColor1",
        "IblColor2",
        "IblColor3",
        "IblColor4",
        "IblColor5",
      }

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        local set_hl = vim.api.nvim_set_hl
        set_hl(0, "IblColor1", { fg = "#88C0D0" }) -- Blue
        set_hl(0, "IblColor2", { fg = "#B48EAD" }) -- Purple
        set_hl(0, "IblColor3", { fg = "#8FBCBB" }) -- Aqua
        set_hl(0, "IblColor4", { fg = "#A3BE8C" }) -- Green
        set_hl(0, "IblColor5", { fg = "#EBCB8B" }) -- Yellow
      end)

      require("ibl").setup({
        scope = { enabled = false },
        indent = {
          char = "│",
          tab_char = "│",
          priority = 2,
          highlight = highlight,
        },
      })
    end
  },

  -- ===== UTILITIES =====
  "nvim-lua/plenary.nvim",
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "nvim-neotest/nvim-nio",
  "karb94/neoscroll.nvim",


  -- ===== AUTOCOMPLETION =====
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "windwp/nvim-autopairs",

  --- ===== COLOR SCHEME ===== ---
  { "AlexvZyl/nordic.nvim" },

  -- ===== FILE EXPLORER =====
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },

  -- ===== BUFFER LINE =====
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },

  -- ===== LSP MANAGER =====
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- ===== WEB DEVELOPMENT =====
  "windwp/nvim-ts-autotag",
  "mattn/emmet-vim",
  "norcalli/nvim-colorizer.lua",
  "brenoprata10/nvim-highlight-colors",

  -- ===== GIT INTEGRATION =====
  "lewis6991/gitsigns.nvim",
  "tpope/vim-fugitive",

  -- ===== TERMINAL =====
  "akinsho/toggleterm.nvim",

  -- ===== C++ DEVELOPMENT =====
  "p00f/clangd_extensions.nvim",

  -- ===== DASHBOARD ===== 
  {
     'goolord/alpha-nvim',
     dependencies = { 'nvim-tree/nvim-web-devicons'},
  }

  })

--------------------------------------------------------------------------------

--- ===== BASIC SETTINGS ===== ---
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = ""
vim.opt.cursorline = true
vim.opt.mouse = "a"

-- activate colorscheme
vim.cmd('colorscheme nordic')

--------------------------------------------------------------------------------

--- ===== TREESITTER & MASON ===== ---
require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "lua", "vim", "vimdoc",
    "javascript", "typescript", "tsx",
    "html", "css", "scss", "json", "jsonc",
    "c", "cpp", "cmake", "make",
    "bash", "yaml", "markdown", "python"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  semantic_tokens = {
    enable = true,
  },
}

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls", "html", "cssls", "jsonls", "emmet_ls", "eslint",
    "clangd", "lua_ls", "pyright", "bashls"
  },
  automatic_installation = true,
})

--------------------------------------------------------------------------------

--- ===== LSP & AUTO COMMANDS ===== ---
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Global LSP keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buf = args.buf

    if client then
      -- Navigation
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf, desc = 'Goto Definition' })
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf, desc = 'Goto Declaration' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = buf, desc = 'References' })
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = buf, desc = 'Goto Implementation' })
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = buf, desc = 'Type Definition' })

      -- Actions
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buf, desc = 'Hover' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = buf, desc = 'Rename' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = buf, desc = 'Code Action' })
      vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end,
        { buffer = buf, desc = 'Format' })

      -- Diagnostics
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = buf, desc = 'Previous Diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = buf, desc = 'Next Diagnostic' })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { buffer = buf, desc = 'Quickfix' })
    end
  end,
})

-- LSP Servers (All Autocmd blocks for start-up)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  callback = function()
    vim.lsp.start({
      name = 'tsserver',
      cmd = { 'typescript-language-server', '--stdio' },
      capabilities = capabilities,
      root_dir = vim.fs.dirname(vim.fs.find({ 'package.json', 'tsconfig.json', 'jsconfig.json' }, { upward = true })[1]),
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html' },
  callback = function()
    vim.lsp.start({
      name = 'html',
      cmd = { 'vscode-html-language-server', '--stdio' },
      capabilities = capabilities,
      root_dir = vim.fs.dirname(vim.fs.find({ 'package.json', '.git' }, { upward = true })[1]),
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'css', 'scss', 'less' },
  callback = function()
    vim.lsp.start({
      name = 'cssls',
      cmd = { 'vscode-css-language-server', '--stdio' },
      capabilities = capabilities,
      root_dir = vim.fs.dirname(vim.fs.find({ 'package.json', '.git' }, { upward = true })[1]),
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua' },
  callback = function()
    vim.lsp.start({
      name = 'lua_ls',
      cmd = { 'lua-language-server', '--stdio' },
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        }
      },
      root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'init.lua' }, { upward = true })[1]),
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.lsp.start({
      name = 'clangd',
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
        "--all-scopes-completion",
        "--completion-style=detailed",
      },
      capabilities = capabilities,
      root_dir = vim.fs.dirname(vim.fs.find({ 'compile_commands.json', 'CMakeLists.txt', '.git' }, { upward = true })[1]),
    })
  end,
})

-- Emmet LSP
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
  callback = function()
    vim.lsp.start({
      name = 'emmet_ls',
      cmd = { 'emmet-ls', '--stdio' },
      capabilities = capabilities,
      root_dir = vim.fs.dirname(vim.fs.find({ 'package.json', '.git' }, { upward = true })[1]),
    })
  end,
})

--- ===== AUTOCOMPLETION (CMP) ===== ---
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Autopairs
require('nvim-autopairs').setup({})

-- Snippets
require("luasnip.loaders.from_vscode").lazy_load()

--- ===== PLUGIN CONFIGURATION ===== ---

-- Automatic Terminal directory SYNC
vim.api.nvim_create_autocmd({"BufEnter", "DirChanged"}, {
  callback = function()
    local current_file_dir = vim.fn.expand('%:p:h')

    if current_file_dir ~= "" and vim.fn.isdirectory(current_file_dir) == 1 then
      vim.cmd("cd " .. vim.fn.fnameescape(current_file_dir))

      local terminals = require("toggleterm.terminal")
      for _, term in ipairs(terminals.get_all()) do

        if term:is_open() and term.job_id then
          local ok, err = pcall(function()
            vim.api.nvim_chan_send(term.job_id, "cd " .. vim.fn.shellescape(current_file_dir) .. "\n")
          end)

        end
      end
    end
  end
})

require('toggleterm').setup({
  open_mapping = [[<c-\>]],
  direction = 'float',

  on_create = function(term)
    local current_file_dir = vim.fn.expand('%:p:h')
    if current_file_dir ~= "" and vim.fn.isdirectory(current_file_dir) == 1 then
      vim.defer_fn(function()
        vim.api.nvim_chan_send(term.job_id, "cd " .. vim.fn.shellescape(current_file_dir) .. "\n")
        vim.api.nvim_chan_send(term.job_id, "clear\n")
      end, 100)
    end
  end,
})

-- DASHBOARD (ALPHA_NVIM)
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  "                                      ",
  "          Welcome to Neovim!          ",
  "          Editing evolved.            ",
  "                                      ",
}

dashboard.section.buttons.val = {
  dashboard.button("f", "🔎  Find file", ":Telescope find_files <CR>"),
  dashboard.button("r", "📄  Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("e", "📁  File explorer", ":Neotree toggle <CR>"),
  dashboard.button("n", "⭐  New file", ":enew <CR>"),
  dashboard.button("c", "⚙️  Config", ":e " .. vim.fn.stdpath("config") .. "/init.lua <CR>"),
  dashboard.button("q", "👋  Quit Neovim", ":qa <CR>"),
  dashboard.button("T", "💻  Terminal (<C-\\>)", ":ToggleTerm <CR>"),
  dashboard.button("H", "❓  Help", ":Telescope help_tags <CR>"),
}

dashboard.section.footer.val = {
  string.format(
    "Neovim v%s.%s.%s | Lazy.nvim",
    vim.version().major,
    vim.version().minor,
    vim.version().patch
  ),
}

alpha.setup({
  layout = {
    { type = "padding", val = 2 },
    dashboard.section.header,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
    { type = "padding", val = 2 },
    dashboard.section.footer,
  },
  opts = {
    margin = 5,
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.line2byte('$') == -1 and vim.bo.buftype == '' then
      vim.cmd("Alpha")
    end
  end,
})

-- Lualine
require('lualine').setup({
  options = {
    theme = 'hyper',
    icons_enabled = true,
  }
})

-- Telescope
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
})

-- Neo-tree
require("neo-tree").setup({
  close_if_last_window = true,
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    }
  }
})

-- Barbar
require('barbar').setup({
  animation = true,
  auto_hide = false,
  tabpages = true,
  clickable = true,
  automatic_colors = true,
  icons = {
    button = 'X',
    pinned = { button = '📌', filename = true },
    inactive = { separator = { left = '', right = '' } },
    current = { button = 'X' },
    modified = { button = '●' },
    separator = { left = '▎', right = '' },
  },
})

-- Git signs
require('gitsigns').setup()

-- ToggleTerm
local Terminal = require("toggleterm.terminal").Terminal

require('toggleterm').setup({
  open_mapping = [[<c-\>]],
  direction = 'float'
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    vim.defer_fn(function()
      local current_file_dir = vim.fn.expand('%:p:h')

      if current_file_dir ~= "" and vim.fn.isdirectory(current_file_dir) == 1 then
        vim.cmd("lcd " .. vim.fn.fnameescape(current_file_dir))

        vim.api.nvim_input("cd " .. current_file_dir .. "<CR>")
        vim.api.nvim_input("clear<CR>")
      else

        local cwd = vim.fn.getcwd()
        vim.api.nvim_input("cd " .. cwd .. "<CR>")
        vim.api.nvim_input("clear<CR>")
      end
    end, 50)
  end,
})

-- Keybinding for Terminal
vim.api.nvim_set_keymap('t', '<C-a>', [[<Cmd>ToggleTerm<CR>]],
  { noremap = true, silent = true, desc = "Close ToggleTerm from Terminal Mode" })

-- Colorizer
require('colorizer').setup({
  '*',
}, {
  RGB = true,
  RRGGBB = true,
  names = true,
  RRGGBBAA = true,
  rgb_fn = true,
  hsl_fn = true,
  css = true,
})

-- Highlight colors
require('nvim-highlight-colors').setup({
  render = 'background',
  enable_named_colors = true,
  enable_tailwind = false,
})

-- Autotag
require('nvim-ts-autotag').setup()

-- Clangd extensions
require('clangd_extensions').setup({})

-- Emmet configuration
vim.g.user_emmet_mode = 'a'
vim.g.user_emmet_leader_key = '<C-y>'
vim.g.user_emmet_settings = {
  javascript = { extends = 'jsx' },
  typescript = { extends = 'jsx' },
  typescriptreact = { extends = 'jsx' },
  html = { extends = 'html' },
}

--- ===== KEYMAPS AND AUTOCMDS ===== ---

-- Barbar buffer navigation
vim.keymap.set('n', '<C-,>', '<Cmd>BufferPrevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<C-.>', '<Cmd>BufferNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<C-1>', '<Cmd>BufferGoto 1<CR>', { desc = 'Buffer 1' })
vim.keymap.set('n', '<C-2>', '<Cmd>BufferGoto 2<CR>', { desc = 'Buffer 2' })
vim.keymap.set('n', '<C-3>', '<Cmd>BufferGoto 3<CR>', { desc = 'Buffer 3' })
vim.keymap.set('n', '<C-4>', '<Cmd>BufferGoto 4<CR>', { desc = 'Buffer 4' })
vim.keymap.set('n', '<C-5>', '<Cmd>BufferGoto 5<CR>', { desc = 'Buffer 5' })
vim.keymap.set('n', '<C-6>', '<Cmd>BufferGoto 6<CR>', { desc = 'Buffer 6' })
vim.keymap.set('n', '<C-7>', '<Cmd>BufferGoto 7<CR>', { desc = 'Buffer 7' })
vim.keymap.set('n', '<C-8>', '<Cmd>BufferGoto 8<CR>', { desc = 'Buffer 8' })
vim.keymap.set('n', '<C-9>', '<Cmd>BufferGoto 9<CR>', { desc = 'Buffer 9' })
vim.keymap.set('n', '<C-0>', '<Cmd>BufferLast<CR>', { desc = 'Last buffer' })
vim.keymap.set('n', '<C-w>', '<Cmd>BufferClose<CR>', { desc = 'Close buffer' })

-- Neo-tree
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Explorer NeoTree' })
vim.keymap.set('n', '<leader>o', '<cmd>Neotree focus<CR>', { desc = 'Focus NeoTree' })
vim.keymap.set('n', '<C-b>', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Explorer' })

-- Telescope
vim.keymap.set('n', '<leader>ff', function() require 'telescope.builtin'.find_files() end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', function() require 'telescope.builtin'.live_grep() end, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fb', function() require 'telescope.builtin'.buffers() end, { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>fh', function() require 'telescope.builtin'.help_tags() end, { desc = 'Find Help' })

-- Terminal
vim.keymap.set('n', '<C-a>', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
vim.keymap.set('n', '<leader>fc', ':ColorizerToggle<CR>', { desc = 'Toggle Colorizer' })
vim.keymap.set('n', '<leader>cd', function()
  local current_file_dir = vim.fn.expand('%:p:h')
  if current_file_dir ~= "" and vim.fn.isdirectory(current_file_dir) == 1 then
    vim.cmd("cd " .. vim.fn.fnameescape(current_file_dir))
    vim.notify("📁 Working directory changed to: " .. current_file_dir)


    local terminals = require("toggleterm.terminal")
    for _, term in ipairs(terminals.get_all()) do
      if term:is_open() then
        vim.api.nvim_chan_send(term.job_id, "cd " .. vim.fn.shellescape(current_file_dir) .. "\n")
      end
    end
  end
end, { desc = 'Sync terminal to current file directory' })

-- Web development (Live Server)
vim.keymap.set('n', '<leader>ls', function()
  local dir = vim.fn.expand('%:p:h')
  if dir == '' then dir = vim.fn.getcwd() end

  local check = vim.fn.system('which live-server')
  if vim.v.shell_error ~= 0 then
    vim.notify("❌ live-server not downloaded. Launch: npm install -g live-server", vim.log.levels.ERROR)
    return
  end

  vim.notify("🚀 Launchin Live Server...")

  local handle = vim.fn.jobstart('live-server --port=8000 --no-browser', {
    cwd = dir,
    detach = true
  })

  if handle > 0 then

    vim.defer_fn(function()

      local browser_handle = vim.fn.jobstart('xdg-open http://localhost:8000', {
        detach = true
      })
      vim.notify("🌐 Live Server launched: http://localhost:8000")
      vim.notify("✨ Changes will update automatically!")
    end, 2000)
  else
    vim.notify("❌ Failed to launch Live Server", vim.log.levels.ERROR)
  end
end, { desc = 'Start Live Server' })

-- Остановка Live Server
vim.keymap.set('n', '<leader>lq', function()
  vim.fn.jobstart('pkill -f "live-server"', { detach = true })
  vim.notify("🛑 Live Server stopped")
end, { desc = 'Stop Live Server' })

-- NPM commands
vim.keymap.set('n', '<leader>nb', ':ToggleTerm size=10 direction=float cmd="npm run build"<CR>',
  { desc = 'NPM Build' })
vim.keymap.set('n', '<leader>nd', ':ToggleTerm size=10 direction=float cmd="npm run dev"<CR>', { desc = 'NPM Dev' })
vim.keymap.set('n', '<leader>ni', ':ToggleTerm size=10 direction=float cmd="npm install"<CR>',
  { desc = 'NPM Install' })

-- C++ commands (CMake)
vim.keymap.set('n', '<leader>cb', ':!cmake -B build -S .<CR>', { desc = 'CMake Build' })
vim.keymap.set('n', '<leader>cm', ':!make -C build<CR>', { desc = 'CMake Make' })
vim.keymap.set('n', '<leader>cr', function()
  local executable = vim.fn.input('Executable: ', './build/', 'file')
  vim.cmd('!./' .. executable)
end, { desc = 'CMake Run' })

-- Git
vim.keymap.set('n', '<leader>gg', ':Git<CR>', { desc = 'Git Status' })
vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = 'Git Push' })


-- ===== PROJECT-SPECIFIC SETTINGS (AUTOCMDS) =====

-- Web projects
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.scss" },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true

    -- Bootstrap/CSS class autocompletions
    vim.keymap.set('n', '<leader>bc', 'iclassName=""<Esc>', { buffer = true, desc = 'Insert className' })
  end
})

-- C++ projects settings and keymaps
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.cpp", "*.hpp", "*.c", "*.h"},
  callback = function()

    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true

    vim.keymap.set('n', '<F5>', function()
      vim.cmd('w')

      local project_dir = vim.fn.expand('%:p:h')
      local filename = vim.fn.expand('%:t')
      local output_name = vim.fn.expand('%:t:r')
      local term_name = "cpp_run_" .. output_name
      local compile_cmd
      local project_type
      local final_command_chain
      local run_cmd = string.format('./"%s"', output_name)

      local has_sdl = vim.fn.isdirectory(project_dir .. '/SDL') == 1
      local has_bgfx = vim.fn.isdirectory(project_dir .. '/bgfx') == 1

      if has_sdl or has_bgfx then
          project_type = "SDL/GameDev"
          
          local include_flags = "-I/usr/include/SDL3 -I/usr/include/SDL3_image -I./SDL"

          local link_flags = "-lSDL3 -lSDL3_image -lpng -ljpeg -ltiff -lwebp -lz"
          
          local rpath_flag = "-Wl,-rpath,/usr/lib"

          compile_cmd = string.format(
              'g++ -g "%s" -o "%s" %s -L. %s %s -std=c++17',
              filename, output_name, include_flags, link_flags, rpath_flag
          )

          local run_cmd_with_path = string.format(
          'LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH ./"%s"', output_name
          )

          final_command_chain = string.format(
              'stty -echo; echo "--- RUNNING %s ---" && %s && %s; exit',
              project_type, compile_cmd, run_cmd_with_path
          )
      else
          project_type = "Standard C++"
          compile_cmd = string.format('g++ -g "%s" -o "%s" -std=c++17', filename, output_name)


          local pause_cmd = 'stty echo; echo "" && echo -n "--- Programm finished. Press ENTER to close. ---" && read; exit'

          local run_sequence = string.format('stty echo; %s; stty -echo', run_cmd)


          final_command_chain = string.format(
              'stty -echo; echo "--- RUNNING %s ---" && %s && %s && %s || (stty echo; echo "Compilation failed or executable not found." && read; exit)',
              project_type, compile_cmd, run_sequence, pause_cmd
          )
      end

      local term = require('toggleterm.terminal').Terminal:new({
        name = term_name,
        direction = 'float',
        close_on_exit = true,
        hidden = false,
        cmd = vim.fn.exepath('zsh'),

        on_open = function(t)
          if vim.b[t.bufnr] and vim.b[t.bufnr].cpp_command_executed then
              vim.cmd("startinsert!")
              return
          end

          vim.defer_fn(function()
            local setup_cmd = string.format("cd %s; clear", vim.fn.shellescape(project_dir))
            vim.api.nvim_chan_send(t.job_id, setup_cmd .. "\n")
            vim.api.nvim_chan_send(t.job_id, final_command_chain .. "\n")

            vim.b[t.bufnr].cpp_command_executed = true
          end, 100)

          vim.cmd("startinsert!")
        end
      })

      term:toggle()

      vim.notify("🚀 Compile and launch... " .. project_type .. " в ToggleTerm...")

    end, { buffer = true, desc = 'Compile & Run C++ Project (Smart F5)' })

  end
})
return
