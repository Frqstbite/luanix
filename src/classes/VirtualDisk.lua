local hardware = require("hardware")

local HardwareKind = require("kinds/HardwareKind")

local JSON = require("libraries/JSON")



local VirtualDisk = {}
VirtualDisk.__index = VirtualDisk



function VirtualDisk.new(id)
    local self = setmetatable({
        _address = 1,
        _content = nil,
    }, {
        __index = VirtualDisk,
    })

    local descriptor = hardware[HardwareKind.storage][id]
    if not descriptor then
        return
    end

    descriptor:seek("set", 0)

    local signature = descriptor:read(4)
    local bootAddress = tonumber(descriptor:read(2))
    local padding = descriptor:read(2)
    local content = JSON.decode(descriptor:read("*a"))

    self._content = content

    return self, {signature, bootAddress, padding}
end


function VirtualDisk:seek(address)
    self._address = address or (self._address + 1)
end


function VirtualDisk:read()
    local data = self._content[self._address]
    
    self:seek()

    return data
end


function VirtualDisk:write(data)
    self._content[self._address] = data
    self:seek()

    
end



return VirtualDisk