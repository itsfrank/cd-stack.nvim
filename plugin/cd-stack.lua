if vim.g.loaded_cd_stack ~= nil then
    return
end
vim.g.loaded_cd_stack = 1

local cd_stack = require("cd-stack")

-- initialize with starting workdir
cd_stack.push_dir(vim.fn.getcwd())

-- this is really just sugar for `:cd` that uses the parent of the current folder when no args provided
-- I don't really expect it to be used with a path, but it's there if you want it
vim.api.nvim_create_user_command("CdstackPush", function(obj)
    local dir = cd_stack.clean_path(vim.fn.expand("%:p:h"))
    if obj.args ~= nil and obj.args ~= "" then
        dir = obj.args
    end
    vim.cmd("cd " .. dir)
end, {
    nargs = "?",
    complete = function(arg_lead, _, _)
        return vim.fn.getcompletion(arg_lead, "dir")
    end,
})

-- pop the pront dir and make then new from cwd
vim.api.nvim_create_user_command("CdstackPop", function()
    cd_stack.pop_dir()
    vim.cmd("cd " .. cd_stack.front_dir())
end, {})

-- change current dir (and top of stack) with one from the stack
vim.api.nvim_create_user_command("CdstackSwitch", function()
    vim.ui.select(cd_stack.get_dirs(), {
        prompt = "Select workdir:",
    }, function(item, idx)
        if item == nil or idx == nil then
            return
        end
        vim.cmd("cd " .. item)
    end)
end, {})

-- move new dir to top of stack
vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "global",
    callback = function()
        local cwd = vim.fn.getcwd()
        cd_stack.push_dir(cwd)
    end,
})
