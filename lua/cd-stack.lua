local cd_stack = {}

---@type string[]
cd_stack.dirs = {}

---read front item
---@return string
function cd_stack.front_dir()
    return cd_stack.dirs[1]
end

---add a directory to the tpo of the stack
---@param dir string
function cd_stack.push_dir(dir)
    if dir == nil then
        return
    end
    dir = cd_stack.clean_path(dir)
    local i = cd_stack.find_dir(dir)
    if i ~= nil or i == 1 then
        if #cd_stack.dirs == 1 then
            return
        end
        cd_stack.pop_dir(i)
    end
    table.insert(cd_stack.dirs, 1, dir)
end

---remove dir from stack
---@param i number|nil index to remove, if nil, remove topmost
---@return string
function cd_stack.pop_dir(i)
    -- dont allow going to 0 (there's always a workdir)
    if #cd_stack.dirs == 1 then
        return cd_stack.front_dir()
    end
    if i == nil then
        i = 1
    end
    return table.remove(cd_stack.dirs, i)
end

---@return string[]
function cd_stack.get_dirs()
    return cd_stack.dirs
end

---find the index of a dir in the stack
---@param q string search query
---@return integer|nil index matching query
function cd_stack.find_dir(q)
    for i, dir in ipairs(cd_stack.dirs) do
        if dir == q then
            return i
        end
    end
    return nil
end

---clean the path (e.g. oil bufer name)
---@param dir string
---@return string
function cd_stack.clean_path(dir)
    if dir == nil or dir == "" then
        return dir
    end
    local prefixes_to_remove = {
        "oil://",
    }
    for _, prefix in ipairs(prefixes_to_remove) do
        if dir:sub(1, #prefix) == prefix then
            return dir:sub(#prefix + 1)
        end
    end
    return dir
end

return cd_stack
