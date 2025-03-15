local cmd = "dbus-monitor"
if vim.fn.executable(cmd) ~= 1 then
  return  -- we need dbus-monitor
end

cmd = {
  cmd, "--binary",
  vim.iter{
    "type=signal",
    "path=/org/freedesktop/portal/desktop",
    "interface=org.freedesktop.portal.Settings",
    "member=SettingChanged",
    "arg0=org.freedesktop.appearance",
    "arg1=color-scheme",
  }:join(","),
}

local opts = {
    text = false,
    clear_env = true,
}

opts.env = {}
local env = vim.uv.os_environ()
for key,val in pairs(env) do
  if key:sub(1, 5) == "DBUS_" then
    table.insert(opts.env, key.."="..val)
  end
end

opts.stdout = function(err, data)
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

opts.stderr = function(err, data)
  assert(not err, err)
  local str = "[STDERR] dbus-monitor: %s"
  local cb = require'my.utils.callback'
  vim.schedule(cb(
    vim.notify,
    str:format(data),
    vim.log.levels.INFO))
end

local onexit = function(obj)
  local str = "[EXIT] dbus-monitor exited (exit code: %d)"
  local cb = require'my.utils.callback'
  vim.schedule(cb(
    vim.notify,
    str:format(obj.code),
    vim.log.levels.INFO))
end

return vim.system(cmd, opts, onexit)
