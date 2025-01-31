local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local M = {}

local function init()
    vim.opt.rtp:prepend(lazypath)
    require'lazy'.setup{
        lockfile = vim.fn.stdpath("data") .. "/lazylock.json",
        install = { colorscheme = { "default" } },
        change_detection = { enabled = false },
        spec = { import = "my.plugins" },
    }
end

local function install()
    local clonecmd = {
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath
    }
    vim.cmd[[ botright new ]]
    vim.api.nvim_win_set_height(0, 5)
    vim.api.nvim_win_set_cursor(0, {1, 0})
    local bufnr = vim.api.nvim_win_get_buf(0)
    vim.fn.termopen(clonecmd, { on_exit = function(_, ec, _)
        if ec == 0 then vim.api.nvim_buf_delete(bufnr, {}) init() end
    end})
end

if not (vim.uv or vim.loop).fs_stat(lazypath)
    then install()
    else init()
end
