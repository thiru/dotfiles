--- A wrapper around vim.pack to make it easier to use.
--- Admittedly, a bit more like lazy.nvim but much simpler.

local M = {}

--- Make adding packages via `vim.pack` more ergonomic.
---@param spec table Essentially vim.pack.Spec with some additional fields:
--- - `enabled` boolean|function: an optional field indicating whether to load this plugin at all
--- - `opts` table|function: optional configuration to pass to the plugin's `setup()` function
---   - can be a table or a function that receives the plugin module and returns a table
--- - `before_load` function: an optional function to run before loading the plugin
--- - `after_load` function: an optional function to run after loading the plugin
---   - the function recieves the required plugin
---@return nil
function M.add(spec)
  -- 1. determine if we should skip loading the plugin
  local skip_load = false

  if spec.enabled ~= nil then
    if type(spec.enabled) == 'function' then
      skip_load = not spec.enabled()
    else
      skip_load = not spec.enabled
    end
  end

  if skip_load then
    return
  end

  -- 2. use local/dev source if applicable
  if spec.dev_src ~= nil then
    local expanded = vim.fs.normalize(vim.fn.expand(spec.dev_src))
    if vim.uv.fs_stat(expanded) then
      spec.src = expanded
    end
  end

  -- 2. load the plugin the simple way
  if spec.before_load == nil and spec.after_load == nil and spec.opts == nil then
    vim.pack.add({spec})
  -- 3. load the plugin with custom loading/setup
  else
    vim.pack.add(
      {spec},
      {
        load = function(plug_data)
          if spec.before_load then spec.before_load(plug_data) end

          vim.cmd.packadd(plug_data.spec.name)
          -- vim.print('packadd: ' .. plug_data.spec.name) -- DEBUG

          local plugin = require(plug_data.spec.name)

          -- auto-run plugin's setup function if applicable
          if spec.opts and plugin.setup then
            local opts = spec.opts
            if type(spec.opts) == 'function' then
              opts = spec.opts(plugin)
            end
            plugin.setup(opts)
            -- vim.print('setup() run for: ' .. plug_data.spec.name) -- DEBUG
          end

          if spec.after_load then spec.after_load(plugin) end
        end})
  end
end

return M
