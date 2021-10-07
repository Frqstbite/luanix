local ThreadScheduler = {}
ThreadScheduler.__index = ThreadScheduler
ThreadScheduler.serviceId = "THRSCH"



function ThreadScheduler.new(kernel)
    return setmetatable({
        _kernel = kernel,
        _schedule = {},
        _upcoming = nil,
    }, ThreadScheduler)
end


function ThreadScheduler:start()
    while true do
        if self._upcoming and os.clock() > self._upcoming then
            local threadContext = table.remove(self._schedule)
            local thread = threadContext.thread

            if coroutine.status(thread) ~= "dead" then
                local upcoming = self._schedule[1]
                self._upcoming = upcoming and upcoming.resumes or nil
                coroutine.resume(thread)
            end
        end
    end
end


function ThreadScheduler:schedule(thread, t)
    t = t or 1
    local resumes = os.clock() + (t / 2)
    
    local pos = 0
    for i, threadContext in ipairs(self._schedule) do
        if threadContext.resumes > resumes then
            pos = i
            break
        end
    end

    local threadContext = {
        thread = thread,
        resumes = resumes,
    }
    
    table.insert(self._schedule, pos + 1, threadContext)

    if not self._upcoming or resumes > self._upcoming then
        self._upcoming = resumes
    end
end



return ThreadScheduler