# dotfiles

## installation

- this will install the configs in this repo to your home directory
- you'll need [GNU Stow](https://www.gnu.org/software/stow)

```shell
git clone https://github.com/thiru/dotfiles
cd dotfiles
stow .
```

## neovim

### [init.lua](./.config/nvim/init.lua)

- this is the starting point
- all configs branch from here

### [lsp/](./.config/nvim/lsp)

- lsp configs are defined here
- note that no external plugins are used to manage lsp servers
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) was used in the past
  - I found it a bit problematic so stopped using it
  - it is still useful to get [lsp configs](https://github.com/neovim/nvim-lspconfig/tree/master/lsp)
- lsp server should be installed manually
  - e.g. via your package manager
- the names of the lsp configs are important and should match the name of the lsp server
  - e.g. **ts_ls** is the name of the typescript language server and so the file is named: [ts_ls.lua](./.config/nvim/lsp/ts_ls.lua)
- [lsp.lua](./.config/nvim/lua/mine/lsp.lua) is responsible for registering the lsp configs

### [lua/mine/](./.config/nvim/lsp)

- core neovim configs are located here
- i.e. there are no plugin-specific configs

### [pack/mine/opt/](./.config/nvim/pack/mine/opt)

- you can place locally developed plugins here
  - and load them with `vim.cmd.packadd`
- see [tabnv.lua](./.config/nvim/plugin/3-tabnv.lua) for an example

### [plugin/](./.config/nvim/plugin)

- plugins are defined here and loaded by neovim in alphanumeric order
  - this is why some files are prefixed with a number so that they are loaded before others
- plugins are managed by neovim's builtin plugin manager: [vim.pack](https://neovim.io/doc/user/pack/#_plugin-manager)
