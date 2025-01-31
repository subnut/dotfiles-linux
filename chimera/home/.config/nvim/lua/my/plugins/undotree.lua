local T = {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
}

T.opts = {
  WindowLayout = 2,
}

T.keys = {
  { "<leader>u", "<cmd>UndotreeToggle<CR>",
    desc = "Toggle UndoTree"
  },
}

T.config = function(_, opts)
  for k, v in pairs(opts) do
    vim.g["undotree_"..k] = v
  end
end

return T
