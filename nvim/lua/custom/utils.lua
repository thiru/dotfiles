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


function _G.nvtmux_auto_started()
  return vim.g.nvtmux_auto_start == true
end

return {
  doc = doc,
}
