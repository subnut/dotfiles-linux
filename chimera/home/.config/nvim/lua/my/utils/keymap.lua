--[[

  NOTE:
       Doesn't support bang versions yet

  USAGE:
      .keymap.n("<leader>h", "<cmd>help<CR>")
      .keymap.i("hello", "bello")
      .keymap.nvi(... , ...)

  EQUIVALENT:
      .keymap.n("<leader>h", ..., ...)
      .keymap.n["<leader>h"](..., ...)
      .keymap.n["<leader>h"] = { ..., ... }

  EQUIVALENT:
      .keymap.ni("hello", "bello")
      .keymap.ni.hello = "bello"
      .keymap.ni.hello("bello")


  ALTERNATIVE USAGE:
      .keymap.n = {
            "hello" = "bello",
            "hiya!" = "byeee",
            "meh" = { ..., ... },
      }
--]]

return setmetatable({}, {
    __index = function(_, idx)
        local mode = setmetatable({}, {__index = table})
        idx:gsub('.', function(c) mode:insert(c) end)
        setmetatable(mode, nil)
        return setmetatable({}, {
            __call = function(_, k, v, o)
                vim.keymap.set(mode, k, v, o)
            end,
            __index = function(_, idx)
                return function(v, o)
                    vim.keymap.set(mode, idx, v, o)
                end
            end,
            __newindex = function(_, idx, val)
                val = type(val) == "table" and val or { val }
                vim.keymap.set(mode, idx, val[1], val[2])
            end
        })
    end,
    __newindex = function(_, idx, val)
        local mode = setmetatable({}, {__index = table})
        idx:gsub('.', function(c) mode:insert(c) end)
        setmetatable(mode, nil)
        for lhs,rhs in pairs(val) do
            rhs = type(rhs) == "table" and rhs or { rhs }
            vim.keymap.set(mode, lhs, rhs[1], rhs[2])
        end
    end,
})
