local hardware = require("hardware")

local HardwareKind = require("kinds/HardwareKind")

local JSON = require("libraries/JSON")



local PartitionDescriptor = {}
PartitionDescriptor.__index = PartitionDescriptor



function PartitionDescriptor.new(disk, num)
    local self = setmetatable({
        disk = disk,
        start = nil,
        finish = nil,
        size = nil,
        _offset = 0,
    }, {
        __index = PartitionDescriptor,
    })

    self:evaluateSize()

    return self
end


function PartitionDescriptor:evaluateSize()
    local masterBootRecord = disk.bootRecord
    local partitions = masterBootRecord[2]

    self.start = partitions[num]
    self.finish = partitions[num + 1] or math.huge
    self.size = self.finish - self.start

    return nil
end


function PartitionDescriptor:seek(offset)
    self._offset = offset or (self._offset + 1)
    return nil
end


function PartitionDescriptor:read()
    if self._offset >= self.size then
        return nil
    end

    self.disk:seek(start + self._offset)
    self:seek()

    return self.disk:read()
end


function PartitionDescriptor:write(data)
    self.disk:seek(start + self._offset)
    self:seek()

    return self.disk:write(data)
end



return PartitionDescriptor