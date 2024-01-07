# cd-stack.nvim

Change the cwd while remembering previous workdirs, return to previous
directories with ease.

**motivation**

Ever used LSP "go to definition" on a dependency and then wanted to perform a
search in that dependency's folder? Only to realize your search keymaps are all
set up for your current workdir that doesn't include the dependeny's files?

cd-stack lets you quickly change the workdir, do what you have to do and then
pop back to your original workdir with ease. And if you happen to need to go to
chained dependencies, the stack has you covered!

## Quickstart

With lazy:

```lua
---@type LazySpec
return {
    "itsfrank/cd-stack.nvim",
    config = function()
        local cd_stack = require("cd-stack")

        -- example keymaps
        vim.keymap.set("n", "<leader>cdd", ":CdstackPush<cr>", { silent = true, desc = "[C][D]stack push" })
        vim.keymap.set("n", "<leader>cdp", ":CdstackPop<cr>", { silent = true, desc = "[C][D]stack [P]op" })
        vim.keymap.set("n", "<leader>cds", ":CdstackSwitch<cr>", { silent = true, desc = "[C][D]stack [S]witch" })
    end,
}
```

## Commands

- `CdstackPush` - add parent of current file to stack and cd to it
- `CdstackPop` - remove current workdir from stack, cd to next dir in stack
- `CdstackSwitch` - cd t another dir in the stack with `vim.ui.select`
