local UniqueIdentifier = require("classes/UniqueIdentifier")
local FileKind = require("kinds/FileKind")
local FileDefaults = require("libraries/FileDefaults")



local VirtualFileSystem = {__index = VirtualFileSystem}



VirtualFileSystem.inode = {__index = VirtualFileSystem.inode}

function VirtualFileSystem.inode.new(vfs, kind, owner, group, pointer)
    local self = setmetatable({
        kind = kind,
        owner = owner,
        group = group,
        perms = FileDefaults[kind].perms,
        pointer = pointer,
    }, VirtualFileSystem.inode)

    FileDefaults[kind].inode(vfs, self)

    return self
end



VirtualFileSystem.dentry = {__index = VirtualFileSystem.dentry}

function VirtualFileSystem.dentry.new(vfs, pointer, name, parent)
    return setmetatable({
        pointer = pointer,
        name = name,
        parent = parent,
    }, VirtualFileSystem.dentry)
end



function VirtualFileSystem.new(kernel)
    return setmetatable({
        _kernel = kernel,

        _inumbers = UniqueIdentifier.new(),
        _inodes = {},
        _payloads = {},

        _dnumbers = UniqueIdentifier.new(),
        _dentries = {},
    }, VirtualFileSystem)
end


function VirtualFileSystem:_validPerms(perms)
    if not perms then
        return false
    end

    if type(perms) ~= "string" then
        return false
    end

    if string.len(perms) ~= 9 then
        return false
    end

    return true
end


function VirtualFileSystem:_validName(name)
    if not name then
        return false
    end

    if string.len(name) > 30 then
        return false
    end

    local cut = string.gsub(name, "[<>:\"/\\|%?%*%s]+", "")
    if cut ~= name then
        return false
    end

    return true
end


function VirtualFileSystem:getINode(pointer)
    return self._inodes[pointer]
end


function VirtualFileSystem:getPayload(pointer)
    return self._payloads[pointer]
end


function VirtualFileSystem:addFile(user, kind, name, parent, ...)
    assert(kind, "[VirtualFileSystem.addFile]: Invalid kind")
    assert(self:_validName(name), "[VirtualFileSystem.addFile]: Invalid name")
    assert(self:getINode(parent), "[VirtualFileSystem.addFile]: Invalid parent")

    local inumber = self._inumbers:get()
    local dnumber = self._dnumbers:get()

    self._payloads[inumber] = FileDefaults[kind].payload(self, ...)

    self._inodes[inumber] = VirtualFileSystem.inode.new(self, kind, owner, group, inumber)
    self._dentries[dnumber] = VirtualFileSystem.dentry.new(self, inumber, name, parent)

    return inumber
end


function VirtualFileSystem:removeFile(user, pathOrNode)

end



return VirtualFileSystem