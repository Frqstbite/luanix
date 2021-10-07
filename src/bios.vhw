--LUANIX BIOS
--equivalent to bios chip

local hardware = require("hardware")

local DiskDescriptor = require("classes/DiskDescriptor")

local HardwareKind = require("kinds/HardwareKind")

local JSON = require("libraries/JSON")



local BOOTFLAG = tonumber(os.getenv("BOOTFLAG"))



local primary = {
    input = nil,
    output = nil,
    storage = nil,
}



--primary input
local keyboards = hardware[HardwareKind.keyboard]
for id, _ in ipairs(keyboards) do
    local descriptor = hardware:get(HardwareKind.keyboard, id)
    
    local valid = (descriptor.read ~= nil)
    descriptor:close()
    
    if valid then
        primary.input = id
        break
    end
end


--primary output
local video = hardware[HardwareKind.video]
for id, _ in ipairs(video) do
    local descriptor = hardware:get(HardwareKind.video, id)
    
    local valid = (descriptor.write ~= nil)
    descriptor:close()

    if valid then
        primary.output = id
        break
    end
end


--primary storage (boot disk)
local storage = hardware[HardwareKind.storage]
for id, _ in ipairs(storage) do
    local descriptor = hardware:get(HardwareKind.storage, id)

    local valid = false
    
    local first = descriptor:read("*l")
    local hasMBR, MBR = pcall(JSON.decode, first)
    if hasMBR then
        if MBR[#MBR] == BOOTFLAG then
            valid = true
        end
    end

    descriptor:close()

    if valid then
        primary.storage = id
        break
    end
end



--attempt boot
if not primary.storage then
    return 0x01
end

if primary.output then
    local descriptor = hardware:get(HardwareKind.video, primary.output)
    local output = ("BOOTABLE DISK: %s %s\n"):format(primary.storage, tostring(hardware:get(HardwareKind.storage, primary.storage)))

    descriptor:write(output)
    descriptor:close()
end

local disk = DiskDescriptor.new(primary.storage)

local bootText = disk.bootRecord[1]
if type(bootText) ~= "string" then
    return 0x02
end

local bootProgram = loadstring(bootText)
if type(bootProgram) == "function" then
    bootProgram()
else
    return 0x03
end


--local installer = require("installer/executable")(1)


return 0x00