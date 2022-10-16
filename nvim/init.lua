local doc = 'Config starting point.'

local bootstrap = require('thiru.bootstrap')
local plugins = require('thiru.plugins')

bootstrap.setup(plugins.setup)
require('thiru.mappings.core').setup()
require('thiru.mappings.plugins').setup()
require('thiru.settings.core').setup()
require('thiru.settings.plugins').setup()
require('thiru.line-endings').setup()
require('thiru.plain-term').setup()

return {
  doc = doc
}
