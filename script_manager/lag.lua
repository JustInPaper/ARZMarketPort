local lag = true
local sampev = require 'samp.events'
function main()
    while not isSampAvailable() do wait(222) end
    AFKMessage('AntiLag-TextDraw By Freym Loaded.')
	wait(-1)
end



function sampev.onShowTextDraw(id,data)
    if data.modelId == 0 and data.zoom ~= 1 and lag == true then
        data.modelId = 1649
        return {id, data}
    end
end

AFKMessage = function(text) 
	sampAddChatMessage('[Freym-tech] {ffffff}'..tostring(text),0xFF4141) 
end