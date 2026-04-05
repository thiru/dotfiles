local p = require('my.packin')

p.add{
  src = 'https://github.com/nvim-mini/mini.clue',
  opts = function(plugin)
    return {
      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        plugin.gen_clues.square_brackets(),
        plugin.gen_clues.builtin_completion(),
        plugin.gen_clues.g(),
        plugin.gen_clues.marks(),
        plugin.gen_clues.registers(),
        plugin.gen_clues.windows(),
        plugin.gen_clues.z(),
      },
      triggers = {
        -- Leader triggers
        { mode = { 'n', 'x' },      keys = '<leader>' },
        { mode = { 'n', 'x' },      keys = '<localleader>' },
        { mode = { 'n', 'x', 't' }, keys = '<C-;>' },

        -- `[` and `]` keys
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = { 'n', 'x' }, keys = 'g' },

        -- Marks
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },

        -- Registers
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = { 'n', 'x' }, keys = 'z' },
      },
      window = {
        delay = 500,
      },
    }
  end
}
