local HardwareKind = require("kinds/HardwareKind")

return {
    [HardwareKind.graphicsCard] = {
        
    },

    [HardwareKind.keyboard] = {
        io.stdin,
    },

    [HardwareKind.storage] = {
        io.open("vosprimary.vhw", "rb"),
    },

    [HardwareKind.video] = {
        io.stdout,
    },
}