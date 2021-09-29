local ProcessManager = {__index = ProcessManager}



function ProcessManager.new(kernel)
    return setmetatable({
        _kernel = kernel,
    }, ProcessManager)
end


function ProcessManager:serviceInit()

end


function ProcessManager:serviceStart()

end



return ProcessManager