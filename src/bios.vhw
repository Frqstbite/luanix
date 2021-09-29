--LUANIX BIOS
--equivalent to bios/uefi chip

local hardware = require("hardware")

local VirtualDisk = require("classes/VirtualDisk")

local HardwareKind = require("kinds/HardwareKind")



local BOOTABLE_FLAG = os.getenv("BOOTFLAG")



local primary = {
    input = nil,
    output = nil,
    storage = nil,
}



--primary input
local keyboards = hardware[HardwareKind.keyboard]
for id, descriptor in ipairs(keyboards) do
    if descriptor.write then
        primary.input = id
    end
end


--primary output
local video = hardware[HardwareKind.video]
for id, descriptor in ipairs(video) do
    if descriptor.write then
        primary.output = id
    end
end


--primary storage (boot disk)
local storage = hardware[HardwareKind.storage]
for id, descriptor in ipairs(storage) do
    local signature = ""
    
    for i = 1, 4 do
        local char = descriptor:read(1)
        if not char then
            break
        end

        signature = signature.. string.byte(char)
    end

    if signature == BOOTABLE_FLAG then --disk is bootable
        primary.storage = id
        break
    end
end



--attempt boot
if not primary.storage then
    if primary.output then
        local descriptor = hardware[HardwareKind.video][primary.output]
        descriptor:write("NO BOOTABLE DISK OR VOLUME WAS DETECTED.", "\n")
    end

    return "NODEV"
end


print("BOOTABLE DISK: ", primary.storage, hardware[HardwareKind.storage][primary.storage])

local disk, MBR = VirtualDisk.new(primary.storage)
disk:seek(MBR[2])

local bootText = disk:read()
if type(bootText) ~= "string" then
    return "NOBOOT"
end

local bootLoader = loadstring(bootText)
if type(bootLoader) == "function" then
    bootLoader()
else
    return "BOOTNLO"
end

return "SUCCESS"