local hardware = require("hardware")

local HardwareKind = require("kinds/HardwareKind")

local JSON = require("libraries/JSON")



return function(id)
    local descriptor = hardware:get(HardwareKind.storage, id, "w")

    local file = io.open("installer/bootloader", "r")
    local bootText = file:read("*a")
    file:close()
    
    local masterBootRecord = {string.gsub(bootText, "[\n\r]+", " "), 2, {0, 16}, 85170}
    local data = {
        -- [[ system partition ]]
        
        --filler data cause its unused
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,


        --[[ primary boot partition ]]
        
        --boot record
        {"LSTDFS"},

        --inode number generator
        {0, {}},
        --inode table
        {
            {
                
            },
        },

        --dentry number gen
        {0, {}},
        --dentry table
        {

        },
    }
    
    descriptor:write(JSON.encode(masterBootRecord), "\n", JSON.encode(data))
end