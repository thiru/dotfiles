local doc = 'Common utilities.'

-- [[ Detect if we're running Windows. ]]
function _G.is_windows()
  return vim.fn.has('win64') ~= 0
end


-- [[ Pretty-print lua values including tables. ]]
function _G.pp(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end


-- [[ Check whether at least the given version of glibc is present. ]]
function _G.has_glibc_version(min_major, min_minor)
  -- print('Requiring glibc: ' .. min_major .. '.' .. min_minor) -- DEBUG
  local handle = io.popen('ldd --version')
  local result = handle:read('*a')
  handle:close()

  local major, minor = result:match('(%d+)%.(%d+)')
  major = tonumber(major)
  minor = tonumber(minor)
  -- print('Detected glibc version: ' .. major .. '.' .. minor) -- DEBUG

  if major < min_major then
    return false
  elseif major == min_major then
    return minor >= min_minor
  end

  return true
end


function _G.nvtmux_auto_started()
  return vim.g.nvtmux_auto_start == true
end

return {
  doc = doc,
}
