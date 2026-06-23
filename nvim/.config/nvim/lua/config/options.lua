local opt = vim.opt

-- Tab / Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = true -- wrapping

-- Search 
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Appearance
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.colorcolumn = '100'
opt.signcolumn = 'yes'
opt.cmdheight = 1
opt.scrolloff = 10
opt.completeopt = "menuone,noinsert,noselect"

-- Behaviour
opt.hidden = true -- change buffers without saving
opt.errorbells = false -- remove bell noise
opt.swapfile = false
opt.backup = false -- no backup or swapfile
opt.undodir = vim.fn.expand("~/.nvim/undodir")
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false
opt.iskeyword:append("-")
-- opt.mouse:append("a")  -- mouse option, disabling for now
opt.clipboard:append("unnamedplus")  -- allows to copy & paste outside of nvim
opt.modifiable = true  -- by default the buffer that you are in 
-- opt.guicursor =  -- setting for cursor 
opt.encoding = "UTF-8"  -- set current buffer to UTF-8