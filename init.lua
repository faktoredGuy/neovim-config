--- ===== LAZY.NVIM SETUP ===== ---
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ===== PLUGINS =====
require("lazy").setup({
  -- ===== CORE PLUGINS =====
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-lualine/lualine.nvim",
  { "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },

  -- ===== UTILITIES =====
  "nvim-lua/plenary.nvim",
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "nvim-neotest/nvim-nio",


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
  -- УБИРАЕМ typescript.nvim - он сломан в новых версиях
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
})

-- ===== BASIC SETTINGS =====
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

-- ===== TREESITTER =====
require'nvim-treesitter.configs'.setup {
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

-- ===== MASON =====
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls", "html", "cssls", "jsonls", "emmet_ls", "eslint",
    "clangd", "lua_ls", "pyright", "bashls"
  },
  automatic_installation = true,
})

-- ===== LSP SETUP (NEW STYLE for Neovim 0.11+) =====
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
      vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, { buffer = buf, desc = 'Format' })
      
      -- Diagnostics
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = buf, desc = 'Previous Diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = buf, desc = 'Next Diagnostic' })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { buffer = buf, desc = 'Quickfix' })
    end
  end,
})

-- LSP Servers (NEW SYNTAX for Neovim 0.11+)
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

-- ===== AUTOCOMPLETION (CMP) =====
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
    ['<CR>'] = cmp.mapping.confirm({ 
      behavior = cmp.ConfirmBehavior.Replace,
      select = true 
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
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

-- ===== PLUGIN CONFIGURATIONS =====

-- Lualine
require('lualine').setup({
  options = { 
    theme = 'auto',
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
require('toggleterm').setup({
  open_mapping = [[<c-\>]],
  direction = 'float'
})

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
  javascript = {extends = 'jsx'},
  typescript = {extends = 'jsx'},
  typescriptreact = {extends = 'jsx'},
  html = {extends = 'html'},
}

--- activate colorscheme
vim.cmd('colorscheme nordic')

-- ===== KEYBINDINGS =====

-- Barbar buffer navigation
vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>', { desc = 'Previous buffer'})
vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>', { desc = 'Next buffer'})
vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', { desc = 'Buffer 1'})
vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', { desc = 'Buffer 2'})
vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', { desc = 'Buffer 3'})
vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', { desc = 'Buffer 4'})
vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', { desc = 'Buffer 5'})
vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', { desc = 'Buffer 6'})
vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', { desc = 'Buffer 7'})
vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', { desc = 'Buffer 8'})
vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', { desc = 'Buffer 9'})
vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', { desc = 'Last buffer'})
vim.keymap.set('n', '<C-w>', '<Cmd>BufferClose<CR>', { desc = 'Close buffer'})

-- Neo-tree
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Explorer NeoTree' })
vim.keymap.set('n', '<leader>o', '<cmd>Neotree focus<CR>', { desc = 'Focus NeoTree' })
vim.keymap.set('n', '<C-b>', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Explorer' })

-- Telescope
vim.keymap.set('n', '<leader>ff', function() require'telescope.builtin'.find_files() end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', function() require'telescope.builtin'.live_grep() end, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fb', function() require'telescope.builtin'.buffers() end, { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>fh', function() require'telescope.builtin'.help_tags() end, { desc = 'Find Help' })

-- Terminal
vim.keymap.set('n', '<leader>tt', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
vim.keymap.set('n', '<leader>fc', ':ColorizerToggle<CR>', { desc = 'Toggle Colorizer' })

-- Web development
vim.keymap.set('n', '<leader>ls', function()
    local dir = vim.fn.expand('%:p:h')
    if dir == '' then dir = vim.fn.getcwd() end
    
    -- Проверяем что live-server установлен
    local check = vim.fn.system('which live-server')
    if vim.v.shell_error ~= 0 then
        vim.notify("❌ live-server не установлен. Запусти: npm install -g live-server", vim.log.levels.ERROR)
        return
    end
    
    vim.notify("🚀 Запускаю Live Server...")
    
    -- Запускаем live-server
    local handle = vim.fn.jobstart('live-server --port=8000 --no-browser', {
        cwd = dir,
        detach = true
    })
    
    if handle > 0 then
        -- Даем серверу время запуститься
        vim.defer_fn(function()
            -- Автоматически открываем браузер
            local browser_handle = vim.fn.jobstart('xdg-open http://localhost:8000', {
                detach = true
            })
            vim.notify("🌐 Live Server запущен: http://localhost:8000")
            vim.notify("✨ Изменения будут автоматически обновляться!")
        end, 2000)
    else
        vim.notify("❌ Не удалось запустить Live Server", vim.log.levels.ERROR)
    end
end, { desc = 'Start Live Server' })

-- Остановить сервер
vim.keymap.set('n', '<leader>lq', function()
    vim.fn.jobstart('pkill -f "live-server"', { detach = true })
    vim.notify("🛑 Live Server остановлен")
end, { desc = 'Stop Live Server' })
-- NPM commands
vim.keymap.set('n', '<leader>nb', ':ToggleTerm size=10 direction=horizontal cmd="npm run build"<CR>', { desc = 'NPM Build' })
vim.keymap.set('n', '<leader>nd', ':ToggleTerm size=10 direction=horizontal cmd="npm run dev"<CR>', { desc = 'NPM Dev' })
vim.keymap.set('n', '<leader>ni', ':ToggleTerm size=10 direction=horizontal cmd="npm install"<CR>', { desc = 'NPM Install' })

-- C++ commands
vim.keymap.set('n', '<leader>cb', ':!cmake -B build -S .<CR>', { desc = 'CMake Build' })
vim.keymap.set('n', '<leader>cm', ':!make -C build<CR>', { desc = 'CMake Make' })
vim.keymap.set('n', '<leader>cr', function()
  local executable = vim.fn.input('Executable: ', './build/', 'file')
  vim.cmd('!./' .. executable)
end, { desc = 'CMake Run' })

-- Git
vim.keymap.set('n', '<leader>gg', ':Git<CR>', { desc = 'Git Status' })
vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = 'Git Push' })

-- ===== PROJECT-SPECIFIC SETTINGS =====

-- Web projects
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.scss"},
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
    
    -- Bootstrap/CSS классы автодополнение
    vim.keymap.set('n', '<leader>bc', 'iclassName=""<Esc>', { buffer = true, desc = 'Insert className' })
  end
})

-- C++ projects
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.cpp", "*.hpp", "*.c", "*.h", "CMakeLists.txt"},
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end
})

-- Auto-close NvimTree if it's the last window
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("Neo-tree") ~= nil then
      vim.cmd "quit"
    end
  end
})

print("🚀 Neovim 0.11+ configuration loaded successfully!")
--- ===== DYNAMIC FONT SIZE ===== --- 

local function update_font_size()
    local width = vim.fn.winwidth(0)
    local base_size = 12
    local font_size
    
    if width > 200 then
        font_size = base_size + math.floor((width - 200) / 30)
    elseif width > 120 then
        font_size = base_size
    else
        font_size = base_size - math.floor((120 - width) / 20)
    end
    
    font_size = math.max(8, math.min(font_size, 24))
    local font_name = "JetBrainsMono-Regular"
    vim.opt.guifont = string.format("%s:h%d", font_name, font_size)
end
--- ===== LIVE SERVER SETTINGS ===== ---

-- Запуск Live Server
vim.keymap.set('n', '<leader>ls', function()
    local dir = vim.fn.expand('%:p:h')
    if dir == '' then dir = vim.fn.getcwd() end
    
    -- Проверяем что live-server установлен
    local check = vim.fn.system('which live-server')
    if vim.v.shell_error ~= 0 then
        vim.notify("❌ live-server не установлен. Запусти: npm install -g live-server", vim.log.levels.ERROR)
        return
    end
    
    vim.notify("🚀 Запускаю Live Server...")
    
    -- Запускаем live-server в фоне
    local handle = vim.fn.jobstart('live-server --port=8000 --no-browser', {
        cwd = dir,
        detach = true
    })
    
    if handle > 0 then
        -- Даем серверу время запуститься
        vim.defer_fn(function()
            -- Автоматически открываем браузер
            local browser_handle = vim.fn.jobstart('xdg-open http://localhost:8000', {
                detach = true
            })
            vim.notify("🌐 Live Server запущен: http://localhost:8000")
            vim.notify("✨ Изменения будут автоматически обновляться!")
        end, 2000)
    else
        vim.notify("❌ Не удалось запустить Live Server", vim.log.levels.ERROR)
    end
end, { desc = 'Start Live Server' })

-- Остановка Live Server
vim.keymap.set('n', '<leader>lq', function()
    local result = vim.fn.system('pkill -f "live-server"')
    vim.notify("🛑 Live Server остановлен")
end, { desc = 'Stop Live Server' })

-- Проверка статуса Live Server
vim.keymap.set('n', '<leader>ll', function()
    local check = vim.fn.system('pgrep -f "live-server"')
    if vim.v.shell_error == 0 then
        vim.notify("✅ Live Server работает")
    else
        vim.notify("❌ Live Server не запущен")
    end
end, { desc = 'Check Live Server status' })
