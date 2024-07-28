local sampev = require("samp.events")
local inicfg = require 'inicfg'
local font = renderCreateFont("Comic Sans MS", 12.5, 12) -- 12.5 это размер шрифта. 12 формат шрифта. Comic Sans MS - название. Можете изменить сами.
local timer_progress = 0
local count = 1
local start_time = os.clock()
math.randomseed(os.clock())
local mainini = inicfg.load({   
    launcher =
    {
        posX = 15, 
        posY = 420,
    }
	}, "acshelper")
inicfg.save(mainini, 'acshelper.ini') 
if not doesFileExist('moonloader/config/acshelper.ini') then
	inicfg.save(mainini,'acshelper.ini')
end

posX = mainini.launcher.posX 
posY = mainini.launcher.posY

function main()
	if not isSampLoaded() then return end
 		while not isSampAvailable() do wait(100) end
		wait(228)
        AFKMessage('ActiveAcs Helper by Freym loaded CMDS: /menuedit | Автор сидит тут: t.me/FREYM_FREYM' ,-1)
        sampRegisterChatCommand("menuedit", function()
            menuedit = not menuedit
            if menuedit == false then
                save_all()
            else
                printString('~G~/menuedit to save settings', 10)
            end
            local bs = raknetNewBitStream()
            raknetBitStreamWriteBool(bs, menuedit)
            raknetEmulRpcReceiveBitStream(83, bs)
            raknetBitStreamWriteInt32(bs, 0)
            raknetDeleteBitStream(bs)
        end) 
    while true do wait(0)
        if menuedit == true then
			posX, posY = getCursorPos()
        end
		if count ~= nil and timer_progress ~= nil then
			if count ~= timer_progress then
				local current_time = os.clock()
				if current_time - start_time >= 0.1 then
                    timer_progress = timer_progress + 1
                    start_time = current_time
                    
                    
				end
			end
			
			local percentage, color, status = calculateProgress(timer_progress,count)
			renderFontDrawText(font, "Status: {"..tostring(color).."}"..tostring(status).." "..tostring(percentage)..'%' , posX, posY, 4294967295.0)
		end
    end
end


function sampev.onSendClickTextDraw(id) 
    if id == 65535 and menuedit == true then
        menuedit = false
        save_all();
    end
end


function calculateProgress(currentValue, maxValue)
	local progress = currentValue / maxValue * 100
	local percentage = math.floor(progress)
	local red = math.floor((100 - percentage) * 255 / 100)
	local green = math.floor(percentage * 255 / 100)
	local color = string.format("%02x%02x%02x", red, green, 0)
	if progress == 100 then
		status = 'Ready'
	else
		status = 'Recharging'
	end
	return progress, color, status
end

function sampev.onSendGiveDamage(playerID, damage, weapon, bodyPart)
	if weapon == 88 then
		count = 100
		start_time = os.clock()
		timer_progress = 0
	end
end

function onScriptTerminate(scr,qgame) --eror
	if scr == thisScript() then
        save_all()
    end
end
function save_all()
    mainini.launcher.posX = posX
    mainini.launcher.posY = posY
    inicfg.save(mainini, "acshelper.ini")
end

AFKMessage = function(text) 
	sampAddChatMessage('[Freym-tech] {ffffff}'..text,0xFF4141) 
end