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
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = function() 
      require("lsp_signature").setup({
        bind = true,
        handler_opts = {
          border = "rounded"
        },
        hint_enable = true,
        hint_prefix = "->",
        hint_scheme = "String",
        hi_parameter = "LspSignatureActiveParameter",
        always_trigger = false,
        max_height = 12,
        max_width = 80,
        floating_window = true,
        floating_window_above_curl_line = true,
        toggle_key = '<C-s>'
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

  { "neovim/nvim-lspconfig", },

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

-- Correct project root detection (CMake / Git)
local function get_project_root()
  local buf_path = vim.fn.expand('%:p:h')
  if buf_path == '' or buf_path == nil then
    return vim.fn.getcwd()
  end

  local root = vim.fs.find(
    { 'CMakeLists.txt', '.git'},
    { upward = true, path = buf_path }
  )[1]

  return root and vim.fs.dirname(root) or vim.fn.getcwd()
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local root = get_project_root()
    if root and root ~= '' and vim.fn.getcwd() ~= root then
      vim.cmd("cd " .. vim.fn.fnameescape(root))
    end
  end,
})

local function has_cmake()
  return vim.fn.filereadable("CMakeLists.txt") == 1
end

local Terminal = require("toggleterm.terminal").Terminal
local build_term = Terminal:new({
  direction = 'float',
  close_on_exit = false,
  shell = 'zsh'
})

local npm_dev = Terminal:new({
  cmd = "npm run dev",
  direction = "float",
  close_on_exit = false,
  shell = "zsh",
  cwd = function()
    return get_project_root()
  end
})
local function run_in_toggleterm(cmd)
  if not build_term:is_open() then
    build_term:open()
  else
    build_term:focus()
  end
  vim.defer_fn(function()
    if build_term.job_id then
      vim.api.nvim_chan_send(build_term.job_id, cmd .. "\n")
    else
      vim.notify("Terminal not ready", vim.log.levels.ERROR)
    end
  end, 200)
end

-- ===== Nvim-DAP (C++ / SDL3) =====

local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = vim.fn.stdpath("data") .. '/mason/bin/OpenDebugAD7',
}

dap.configurations.cpp = {
  {
    name = "Debug SDL3 (CMake)",
    type = "cppdbg",
    request = "launch",
    program = function ()
      return get_project_root() .. "/build/game"
    end,

    cwd = function()
      return get_project_root()
    end,
    stopAtEntry = false,
    MIMode = "gdb",
    setupCommands = {
      {
        description = "Enable pretty printing",
        text = "-enable-pretty-printing",
        ignoreFailures = true,
      },
    },
  }
}

dap.configurations.c = dap.configurations.cpp

-- Debug keymaps
vim.keymap.set('n', '<F5>', function()
  if has_cmake() then
    -- CMake + DAP
  local exe = get_project_root() .. "/build/game"
  if vim.fn.filereadable(exe) == 0 then
    vim.notify("Binary not found, run <leader>mb first", vim.log.levels.WARN)
    return
  end
  require("dap").run(require("dap").configurations.cpp[1])
  else
    -- Direct compilation
    local file = vim.fn.expand('%:p')
    local output = vim.fn.expand('%:r')

    local cmd = string.format(
      "g++ -std=c++20 -Wall -Wextra %s -o %s && ./%s",
      file, output, output
    )
    run_in_toggleterm(cmd)
  end
end, { desc = 'DAP Continue' })

vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'DAP Step Over' })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'DAP Step Into' })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'DAP Step Out' })
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP Toggle Breakpoint' })

dap.listeners.after.event_initialized["dapui"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui"] = function()
  dapui.close()
end

-- ===== FIXED CMake RUN (SDL3) =====
vim.keymap.set('n', '<leader>mr', function()
  local project_dir = get_project_root()
  local Terminal = require('toggleterm.terminal').Terminal
  
  local cmd = [[
    set -e
    cd "]] .. project_dir .. [["
    cmake -B build -S .
    cmake --build build -j$(nproc)
    cd build
    ./game
    echo ""
    echo "Program finished. Press Ctrl+A to exit."
    ]]
    run_in_toggleterm(cmd)
end, { desc = 'CMake Build & Run (fixed root)' })

vim.keymap.set('n', '<leader>mx', function()
  local cmd = table.concat({
    'echo "🔍 Checking build environment..."',
    'echo "CWD: $(pwd)"',
    'echo "PATH: $PATH"',
    'which cmake || echo "Error: cmake: NOT FOUND"',
    'which g++ || echo "Error: g++: NOT FOUND"',
    'which make || echo "Error: make: NOT FOUND"',
    'cmake --version | head -1',
    'echo ""',
    'echo "📁 Current project:"',
    'ls -la CMakeLists.txt 2>/dev/null && echo "✅ CMakeLists.txt exists" || echo "Error: CMakeLists.txt not found"',
    'echo ""',
    'echo "Press Ctrl+A to exit."'
  }, ' && ')
  run_in_toggleterm(cmd)
end, {desc = 'Check build environment'})

vim.keymap.set('n', '<leader>mR', function()
  local project_dir = get_project_root()

  local cmd = table.concat({
    'set -e',
    'cd "' .. project_dir .. '"',
    'echo "🔄 Reconfiguring CMake..."',
    'rm -rf build',
    'cmake -B build -S .',
    'echo "🔨 Building..."',
    'cmake --build build -j$(nproc)',
    'echo "🎮 Running..."',
    'cd build',
    './game',
    'echo ""',
    'echo "🎯 Program finished. Press Ctrl+A to exit."'
  }, ' && ')

  run_in_toggleterm(cmd)
end, { desc = 'CMake Clean Build & Run' })

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


vim.lsp.config.clangd = {
  capabilities = capabilities,
  cmd = { "clangd",
  "--background-index",
  "--clang-tidy",
  "--compile-commands-dir=build"
  },
}

vim.lsp.enable("clangd")

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

-- Automaticly generate compile_commands.json at changing CMakeLists.txt file
vim.api.nvim_create_autocmd({"BufWritePost"}, {
  pattern = "CMakeLists.txt",
  callback = function()
    local project_dir = get_project_root()
    local build_dir = project_dir .. '/build'

    if vim.fn.isdirectory(build_dir) == 1 then
      vim.fn.jobstart({'sh', '-c',
      'cd "' .. project_dir .. '" && ' ..
      'cmake -B build -S .'
      },
      {
        on_exit = function(_, code)
        if code == 0 then
          vim.notify("✅ CMake reconfigured", vim.log.levels.INFO)
        else
          vim.notify("❌ CMake reconfiguration failed", vim.log.levels.ERROR)
    end
  end
    })
    end
  end,
})

vim.keymap.set('n', '<leader>pv', function()
  local project_dir = get_project_root()
  local dirs = {
    'src',
    'include',
    'lib',
    'SDL',
    'assets',
    'build'
  }

  local message = "📁 Project Structure:\n\n"

  for _, dir in ipairs(dirs) do
    local full_path = project_dir .. '/' .. dir
    if vim.fn.isdirectory(full_path) == 1 then
      -- Считаем файлы
      local count = 0
      if dir == 'src' or dir == 'include' or dir == 'assets' then
        count = tonumber(vim.fn.system('find "' .. full_path .. '" -type f | wc -l')) or 0
        message = message .. string.format("✅ %s/ (%d files)\n", dir, count)
      else
        message = message .. string.format("✅ %s/\n", dir)
      end
    else
      message = message .. string.format("❌ %s/\n", dir)
    end
  end

  if vim.fn.filereadable(project_dir .. '/CMakeLists.txt') == 1 then
    message = message .. "\n✅ CMakeLists.txt"
  else
    message = message .. "\n❌ CMakeLists.txt"
  end

  vim.notify(message, vim.log.levels.INFO, { title = "Project Check" })
end, { desc = 'Verify project structure' })

vim.keymap.set('n', '<leader>?', function()
  vim.notify([[
🎮 C++ Project Commands (CMake only):
  
Main Command:
  <F5> - Build & Run project (auto-detects/creates CMakeLists.txt)
  
CMake Commands:
  <leader>mc - Clean configure CMake
  <leader>mb - Build only
  <leader>mr - Build & Run
  <leader>mC - Clean build directory
  <leader>mj - Generate compile_commands.json for LSP
  <leader>mR - Cmake Clean Build & Run
  <leader>mx - Check build environment
  
Project Navigation:
  <leader>ps - Open src/
  <leader>pi - Open include/
  <leader>pa - Open assets/
  <leader>pb - Open build/
  <leader>ch - Switch header/source
  <leader>pv - Verify project structure
  
Note: Press Ctrl+\\ to open terminal, Ctrl+D to exit.
  ]], vim.log.levels.INFO, { title = "Help: CMake Commands" })
end, { desc = 'Show CMake commands help' })

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

require('toggleterm').setup({
  open_mapping = [[<c-\>]],
  direction = 'float',
  shell = 'zsh',

  cwd = function()
    return get_project_root()
  end,
})

-- DASHBOARD (ALPHA_NVIM)
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  "                                      ",
  "          Neovim.                     ",
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
    bind_to_cwd = true,

    follow_current_file = {
      enabled = true,
      leave_dirs_open = true,
    },
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    }
  }
})

-- Project structure navigation
vim.keymap.set('n', '<leader>ps', function()
  if vim.fn.isdirectory('src') == 1 then
    vim.cmd('edit src/')
  else
    vim.notify(" src/ directory not found", vim.log.levels.WARN)
  end
end, { desc = 'Open src directory' })

vim.keymap.set('n', '<leader>pi', function()
  if vim.fn.isdirectory('include') == 1 then
    vim.cmd('edit include/')
  else
    vim.notify(" include/ directory not found", vim.log.levels.WARN)
  end
end, { desc = 'Open include directory' })

vim.keymap.set('n', '<leader>pa', function()
  if vim.fn.isdirectory('assets') == 1 then
    vim.cmd('edit assets/')
  else
    vim.notify(" assets/ directory not found", vim.log.levels.WARN)
  end
end, { desc = 'Open assets directory' })

vim.keymap.set('n', '<leader>pb', function()
  if vim.fn.isdirectory('build') == 1 then
    vim.cmd('edit build/')
  else
    vim.notify(" build/ directory not found", vim.log.levels.WARN)
  end
end, { desc = 'Open build directory' })

-- Switch between header and source
vim.keymap.set('n', '<leader>ch', function()
  local current_file = vim.fn.expand('%:p')
  local file_name = vim.fn.expand('%:t:r')
  local ext = vim.fn.expand('%:e')

  if current_file:match('/src/') and (ext == 'cpp' or ext == 'c') then

    local header_file = vim.fn.expand('%:p:h:h') .. '/include/' .. file_name .. '.h'
    if vim.fn.filereadable(header_file) == 1 then
      vim.cmd('edit ' .. header_file)
    else
      vim.notify('Header not found: ' .. header_file, vim.log.levels.WARN)
    end
  elseif current_file:match('/include/') and ext == 'h' then
    -- Из include в src
    local src_file = vim.fn.expand('%:p:h:h') .. '/src/' .. file_name .. '.cpp'
    if vim.fn.filereadable(src_file) == 1 then
      vim.cmd('edit ' .. src_file)
    else
      -- Проверяем .c файл
      src_file = vim.fn.expand('%:p:h:h') .. '/src/' .. file_name .. '.c'
      if vim.fn.filereadable(src_file) == 1 then
        vim.cmd('edit ' .. src_file)
      else
        vim.notify('Source file not found', vim.log.levels.WARN)
      end
    end
  end
end, { desc = 'Switch header/source' })

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
require('clangd_extensions').setup({
  server = {
    autostart = false,
  }  
})

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
  local dir = get_project_root()
  if dir == '' then return end

  vim.notify("Sync terminals to: " .. dir)

  local terminals = require("toggleterm.terminal")
  for _, term in ipairs(terminals.get_all()) do
    if term:is_open() then
      vim.api.nvim_chan_send(term.job_id, "cd " .. vim.fn.shellescape(dir) .. "\n")
    end
  end
end, { desc = 'Sync terminal to current file directory' })

-- Web development (Live Server)
vim.keymap.set('n', '<leader>ls', function()
  local dir = get_project_root()
  if dir == '' then dir = vim.fn.getcwd() end

  local check = vim.fn.system('which live-server')
  if vim.v.shell_error ~= 0 then
    vim.notify(" live-server not downloaded. Launch: npm install -g live-server", vim.log.levels.ERROR)
    return
  end

  vim.notify(" Launchin Live Server...")

  local handle = vim.fn.jobstart('live-server --port=8000 --no-browser', {
    cwd = dir,
    detach = true
  })

  if handle > 0 then

    vim.defer_fn(function()

      local browser_handle = vim.fn.jobstart('xdg-open http://localhost:8000', {
        detach = true
      })
      vim.notify(" Live Server launched: http://localhost:8000")
      vim.notify(" Changes will update automatically!")
    end, 2000)
  else
    vim.notify(" Failed to launch Live Server", vim.log.levels.ERROR)
  end
end, { desc = 'Start Live Server' })

-- Stop Live Server
vim.keymap.set('n', '<leader>lq', function()
  vim.fn.jobstart('pkill -f "live-server"', { detach = true })
  vim.notify(" Live Server stopped")
end, { desc = 'Stop Live Server' })

-- NPM commands
vim.keymap.set('n', '<leader>nb', function() run_in_toggleterm('npm run build') end,
  { desc = 'NPM Build' })
vim.keymap.set('n', '<leader>nd', function()
  npm_dev:toggle()
end, { desc = 'NPM dev'})
vim.keymap.set('n', '<leader>ni', function () run_in_toggleterm('npm install') end,
  { desc = 'NPM Install' })

-- C++ commands (CMake)

vim.keymap.set('n', '<leader>mc', function()
  local project_dir = get_project_root()

  local cmd = [[
cd "]] .. project_dir .. [["
echo "🛠️ Configuring CMake..."

rm -rf build

if ! command -v cmake >/dev/null; then
  echo "❌ CMake not found"
  return
fi

cmake -B build -S .
if [ $? -ne 0 ]; then
  echo "❌ CMake configuration failed"
  return
fi

echo "✅ CMake configured successfully"
echo ""
echo "Press Ctrl+A to exit."
]]

  run_in_toggleterm(cmd)
end, { desc = 'CMake Configure' })



vim.keymap.set('n', '<leader>mb', function()
  local project_dir = get_project_root()
  if project_dir == '' then project_dir = vim.fn.getcwd() end

  local build_dir = project_dir .. '/build'
  if vim.fn.isdirectory(build_dir) == 0 then
    vim.notify("Error: Build directory not found. Run <leader>mc first", vim.log.levels.ERROR)
    return
  end

  local cmd = [[
    cd "]] .. project_dir .. [["
    echo "🔨 Building project..."

    if ! command -v cmake >/dev/null; then
      echo "❌ CMake not found"
      exit 1
    fi

    cmake --build build -j$(nproc)
    BUILD_STATUS=$?

    if [ $BUILD_STATUS -ne 0 ]; then
      echo "❌ Build failed"
      exit 1
    fi

    echo "✅ Build successful"

    ls -la build | grep -E 'game|SDL' || echo "⚠️ No executable found in build/"

    echo ""
    echo "Press Ctrl+A to exit."
  ]]

  run_in_toggleterm(cmd)
end, { desc = 'CMake Build' })

vim.keymap.set('n', '<leader>mC', function()
  local project_dir = get_project_root()

  local cmd = table.concat({
    'cd "' .. project_dir .. '"',
    'echo "🧹 Cleaning build directory..."',
    'rm -rf build',
    'mkdir -p build',
    'echo "✅ Build directory cleaned."',
    'echo ""',
    'echo "Press Ctrl+A to exit."'
  }, ' && ')

  run_in_toggleterm(cmd)
end, { desc = 'CMake Clean' })

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

-- C++ projects
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile" }, {
  pattern = { "*.cpp", "*.h", "*.hpp", "*.txt", "*.c"},
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
    vim.bo.smartindent = true
    
    vim.bo.cinoptions = vim.bo.cinoptions .. ":0,g0,N-s,(0,w1,W4"
    vim.bo.cindent = true
  end
})
