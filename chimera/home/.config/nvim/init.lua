vim.o.title      = true
vim.o.smartcase  = true
vim.o.ignorecase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile   = true

vim.g.mapleader         = " "
vim.g.maplocalleader    = "\\"

vim.opt.lcs = {
    nbsp     = "+",
    lead     = "·",
    trail    = "🁢",
    tab      = ">-",    -- two characters
    extends  = "»",
    precedes = "«",
    multispace = "·",
}

require'my.utils.keymap'.n = {
    ["<leader>y"] = '"+y',
    ["<leader>p"] = '"+p',
    ["<leader>l"] = "<cmd>set list!<CR>",
    ["<leader>w"] = "<cmd>set wrap!<CR>",
    ["<leader>N"] = "<cmd>set rnu!<CR>",
    ["<leader>n"] = "<cmd>set nu!<CR>",
}

-- Start monitoring dbus
require'my.utils.dbusmonbg'

-- Load plugins
require'my.utils.pluginit'
