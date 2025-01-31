local T = {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  branch = "v3.x",
  cmd = "Neotree",
  keys = { insert = table.insert }
}

T.keys:insert{
  "<leader>e",
  "<cmd>Neotree toggle<cr>",
  desc = "Toggle NeoTree",
}

T.opts = {
  popup_border_style = "rounded"
}

T.opts.window = {
  mappings = {
    ["<Tab>"] = "toggle_node",
    ["<Space>"] = "noop", -- :h mapleader
  },
}
T.opts.window.mappings.s = "open_split"
T.opts.window.mappings.S = "open_vsplit"

T.opts.filesystem = {
  cwd_target = {
    sidebar = "global",
    current = "tab",  -- Netrw style
  }
}

T.opts.source_selector = {
  separator = "",
  statusline = true,
  content_layout = "center",
  highlight_tab = "TabLineFill",
  highlight_tab_active = "TabLine",
  highlight_background = "TabLineFill",
}

T.opts.event_handlers = {
  insert = table.insert
}
T.opts.event_handlers:insert{
  event = "file_open_requested",
  handler = function()
    require'neo-tree.command'.execute{
      action = "close"
    }
  end,
}

return T
