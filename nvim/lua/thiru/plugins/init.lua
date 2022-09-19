local doc = 'Plugin setup/registration/bootstrapping.'

local bootstrap = require('thiru.plugins.bootstrap')
local registrar = require('thiru.plugins.registrar')

local function setup()
  bootstrap.setup(registrar.setup)
end

return {
  doc = doc,
  setup = setup
}
