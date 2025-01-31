local T = {
  "lewis6991/gitsigns.nvim",
  version = "*",
  config = true,
  opts = {},
}

T.opts.on_attach = function(b)
  local map = setmetatable({}, {
    __index = function(_, m) return function(k, c, o)
      if o then o.buffer = b else o = {buffer = b} end
      vim.keymap.set(m, k, c, o)
    end end
  })

  local gs = require'gitsigns'
  local cb = require'my.utils.callback'

  map.n('<leader>gp', gs.preview_hunk)
  map.n('<leader>gr', gs.reset_hunk)
  map.n('<leader>ga', gs.stage_hunk)
  map.n('<leader>gu', gs.undo_stage_hunk)

  local navopts = {
    target = "all",
    greedy = false,
  }
  map.n(']g', cb(gs.nav_hunk, "next", navopts))
  map.n('[g', cb(gs.nav_hunk, "prev", navopts))
  map.n(']G', cb(gs.nav_hunk, "last", navopts))
  map.n('[G', cb(gs.nav_hunk, "first", navopts))
end

if vim.v.progname == "vim" then
  T.opts.signs = {
    add           = { text = "+" },
    change        = { text = "~" },
    delete        = { text = "-" },
    topdelete     = { text = "-" },
    changedelete  = { text = "~" },
  }
end

return T
