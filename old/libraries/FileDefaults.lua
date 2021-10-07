local Symbol = require("./classes/Symbol")
local FileKind = require("./kinds/FileKind")



return {
    [FileKind.device] = {
        perms = "110110110",

        inode = function(vfs, inode)
            
        end,

        payload = function(vfs, inode)
            return Symbol.new("payload", "vfs")
        end,
    },

    [FileKind.directory] = {
        perms = "111111110",

        inode = function(vfs, inode)
            function inode:lookup(search)
                local payload = vfs:getPayload(inode.pointer)

                for dnumber, dentry in pairs(payload) do
                    if type(search) == "number" then
                        if dentry.pointer == search then
                            return dentry
                        end
                    elseif type(search) == "string" then
                        if dentry.name == search then
                            return dentry
                        end
                    end
                end
            end
        end,

        payload = function(vfs, inode)
            return {}
        end,
    },

    [FileKind.regular] = {
        perms = "110100100",

        inode = function(vfs, inode)
            
        end,

        payload = function(payload)
            return payload or {}
        end,
    },

    [FileKind.symbolic] = {
        perms = "",

        inode = function(vfs, inode)
            
        end,

        payload = function(dest)
            return dest
        end,
    },
}