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

return {
  doc = doc,
}
