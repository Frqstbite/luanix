local hardware = require("hardware")

local PartitionDescriptor = require("classes/PartitionDescriptor")

local HardwareKind = require("kinds/HardwareKind")

local JSON = require("libraries/JSON")



local DiskDescriptor = {}
DiskDescriptor.__index = DiskDescriptor



function DiskDescriptor.new(id)
    local self = setmetatable({
        id = id,
        bootRecord = nil,
        
        _content = {},
        _offset = 0,
        _partitionCache = {},
    }, {
        __index = DiskDescriptor,
    })

    local descriptor = hardware:get(HardwareKind.storage, id)
    assert(descriptor, "[DiskDescriptor] Invalid id ".. tostring(id))

    self.bootRecord = JSON.decode(descriptor:read("*l"))
    
    self._content = JSON.decode(descriptor:read("*a"))

    return self
end


function DiskDescriptor:getPartition(num)
    local descriptor = self._partitionCache[num]
    
    if not descriptor then
        descriptor = PartitionDescriptor.new(self, num)
        self._partitionCache[num] = descriptor
    end
    
    return descriptor
end


function DiskDescriptor:seek(offset)
    self._offset = offset or (self._offset + 1)

    return nil
end


function DiskDescriptor:read()
    local data = self._content[self._offset + 1]

    return data
end


function DiskDescriptor:write(data)
    self._content[self._offset + 1] = data

    return nil
end



return DiskDescriptor