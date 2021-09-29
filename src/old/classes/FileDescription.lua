local FileDescription = {}



function FileDescription.new(inode, mode)
    return setmetatable({
        inode = mode,
        mode = mode,
    }, {
        __index = FileDescription,
    })
end



return FileDescription