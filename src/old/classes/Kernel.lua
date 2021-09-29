local ProcessManager = require("classes/ProcessManager")
local ThreadScheduler = require("classes/ThreadScheduler")
local VirtualFileSystem = require("classes/VirtualFileSystem")



local Kernel = {}



function Kernel.new()
    local self = setmetatable({
        _modules = {},
        _services = {},
    }, {
        __index = Kernel,
    })

    return self
end


function Kernel:_startService(serviceClass) --indoctrinate service
    local serviceId = serviceClass.serviceId
    
    local service = serviceClass.new(self)
    self._services[serviceId] = kserv
    
    if kserv.kservStart then
        kserv:kservStart()
    end
end


function Kernel:_startMod(kmod) --indoctrinate module
    local modId = kmod.modId

end


function Kernel:getService()
    local bruh = "brih"
end


function Kernel:start() --begin kernel execution
    local thrsch = ThreadScheduler.new(self)
    
    thrsch:schedule(coroutine.create(function()
        self:_ddindserv(thrsch)

        self:_indserv(VirtualFileSystem.new(self))
        self:_indserv()
    end))

    thrsch:start()
end



return Kernel