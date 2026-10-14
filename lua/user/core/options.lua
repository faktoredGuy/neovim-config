local opt = vim.opt

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.cursorline = false
opt.splitright = true
opt.splitbelow = true
opt.inccommand = "split"

opt.isfname:append("@-@")
opt.updatetime = 250
opt.colorcolumn = ""
opt.mouse = "a"
opt.showcmd = true
opt.showmode = false
