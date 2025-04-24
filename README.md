# What's that?

The nvim plugin to import plugins from Yandex Arcadia.
Imported plugins will work even if Aracdia is not mounted.

# Quickstart 

## Installation 

Install the plugin via the following command in `init.lua`:

```lua
Plug('segoon/arc-plug.nvim')
...

-- Import any plugins you like
require('arc-plug').setup({
  'devtools/vim/syntax_highlight/yamake',
  'junk/moonw1nd/lua/telescope-arc.nvim',
})
```

To install/update the plugins type the following:
```
:ArcPlugInstall
```
