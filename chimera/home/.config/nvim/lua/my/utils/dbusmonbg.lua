local cmd = "dbus-monitor"
if vim.fn.executable(cmd) ~= 1 then
  return  -- we need dbus-monitor
end

local M = {}
local opts = {}
local uv = vim.uv

opts.args = {
  "--binary", vim.iter{
    "type=signal",
    "path=/org/freedesktop/portal/desktop",
    "interface=org.freedesktop.portal.Settings",
    "member=SettingChanged",
    "arg0=org.freedesktop.appearance",
    "arg1=color-scheme",
  }:join(","),
}

local stdout = uv.new_pipe()
local stderr = uv.new_pipe()
opts.stdio = { nil, stdout, stderr }

opts.env = {}
local env = uv.os_environ()
for key,val in pairs(env) do
  if key:sub(1, 5) == "DBUS_" then
    table.insert(opts.env, key.."="..val)
  end
end

local stdout_handler = function (err, data)
  assert(not err, err)
  if data == nil then
    return  -- EOF
  end
  local sig = "\x01u\x00"
  local idx = data:reverse()
                  :find(sig:reverse())
  if idx == nil then
    return  -- Wrong message.
  end
  local bgcb = function(bg) return
    function() vim.o.bg = bg end
  end
  local data = data:sub(-idx)
  if data:match("\x01") == nil  -- ie. color-scheme != 1
    then vim.schedule(bgcb("light"))
    else vim.schedule(bgcb("dark"))
  end
end

local sigtbl = { insert = table.insert }
for key,val in pairs(uv.constants) do
    if key:sub(1, 3) == "SIG" then
        sigtbl:insert(val, key)
    end
end
local onexit = function(code, signal)
  local cb = require'my.utils.callback'
  local str = "[EXIT] dbus-monitor exited "
  if signal == 0
  then
      str = str .. "(exit code: %d)"
      str = str:format(code)
  else
      str = str .. "(signal: %s)"
      str = str:format(sigtbl[signal])
  end
  vim.schedule(cb(
    vim.notify, str,
    vim.log.levels.INFO))
end

opts.detached = false
M.process, M.pid = uv.spawn(
  cmd, opts, onexit
)

stdout:read_start(stdout_handler)
stderr:read_start(function(err, data)
  assert(not err, err)
  local str = "[STDERR] dbus-monitor: %s"
  local cb = require'my.utils.callback'
  vim.schedule(cb(
    vim.notify,
    str:format(data),
    vim.log.levels.INFO))
end)

vim.api.nvim_create_autocmd("VimLeave", {
    desc = "[dbusmonbg] autocmd to kill dbus-monitor",
    callback = function(_) M.process:kill(uv.constants.SIGHUP) end,
    once = true,
})

return M
