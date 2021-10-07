local HardwareKind = require("kinds/HardwareKind")

local JSON = require("libraries/JSON")



local PERIPHERAL_PATH = "peripherals/"



local peripherals = {
    [HardwareKind.keyboard] = {io.stdin},
    [HardwareKind.storage] = {"luxstorage"},
    [HardwareKind.video] = {io.stdout},
}



local Hardware = setmetatable({
    _cache = {},
}, {
    __index = peripherals
})



function Hardware:get(kind, id, mode)
    local file = nil
    local cache = self._cache[kind]

    if not cache then
        cache = {}
        self._cache[kind] = cache
    else
        file = cache[id]
    end

    if not file then
        file = peripherals[kind][id]
        cache[id] = file
    end

    if type(file) == "string" then
        return io.open(PERIPHERAL_PATH.. file.. ".vhw", mode or "r+")
    else
        return file
    end
end



return Hardware