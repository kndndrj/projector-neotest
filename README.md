# Neovim Projector Neotest Extension

Extension for [nvim-projector](https://github.com/kndndrj/nvim-projector) that
adds an output with [nvim-projector](https://github.com/nvim-neotest/neotest)
support.

## Installation

Install it as any other plugin. and add outputs to `projector`'s setup function.
This extension also needs neotest to be installed and configured properly.

```lua
require("projector").setup {
  outputs = {
    require("projector_neotest").OutputBuilder:new(),
    -- ... your other outputs
  },
  -- ... the rest of your config
}
```

This output adds additional tasks to manage tests to projector.

You can pass an optional table parameter to `new()` function. Here are the
available options with defaults:

```lua
{
  group = false, -- group the created tasks together under one node
  include_debug = false, -- include debuggin tasks (nvim-dap needed)
}
```
