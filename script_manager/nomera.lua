
local sampev = require "samp.events"


function main()
    repeat wait(0) until isSampAvailable()

    while true do
        
		local resultrrggggg, buttonrrfwgwgwgwgw, _, inputrfwfwfwrf = sampHasDialogRespond(9989)
		if resultrrggggg and buttonrrfwgwgwgwgw == 1 then
			kod_regiona = inputrfwfwfwrf
		end
        wait(0)
    end
end


function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, text)
    if text:find('Получение номерного знака') and text:find('Поиск угнанных авто') and text:find('Сдача с повинной') then
        local text = text .. '\n{ff6666}[5] {ffffff}Быстро получить номерной знак [RU {33AA33}'..tostring(kod_regiona)..'{FFFFFF}]\n{ff6666}[6] {ffffff}Выбрать код региона для быстрого получения гос-знака'
        return {dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, text}
    end
end


function sampev.onSendDialogResponse(dialogid, button, list, text) --отправка диалога
	if text:find('Быстро получить номерной знак') and kod_regiona == nil and button == 1 then
		-- AFKMessage('??')
		lua_thread.create(function()
			wait(100)
			sampShowDialog(9989, " ", "{FFFFFF}Введите код города для номерного знака!", "Выбрать", "Закрыть", 1)
		end)
	elseif text:find('Быстро получить номерной знак') and kod_regiona ~= nil and button == 1 then
		fast_nomera = true
		sampSendDialogResponse(dialogid, 1, 1, false)
		-- AFKMessage('oj')
		return false
	end
	if text:find('Выбрать код региона для быстрого получения') and button == 1 then
		lua_thread.create(function()
			wait(100)
			sampShowDialog(9989, " ", "{FFFFFF}Введите код города для номерного знака!", "Выбрать", "Закрыть", 1)
		end)
	end

end


function onReceivePacket(id, bitStream)
	if (id == 220) then
		raknetBitStreamIgnoreBits(bitStream, 8)
		if (raknetBitStreamReadInt8(bitStream) == 17) then
			raknetBitStreamIgnoreBits(bitStream, 32)
			cefstr = raknetBitStreamReadString(bitStream, raknetBitStreamReadInt32(bitStream))
		end
	end
    if cefstr ~= nil then
        if cefstr:find('event.setActiveView') and cefstr:find('CarNumbers') and fast_nomera == true then
            local str = 'carNumbers.purchase|rus|'..tostring(kod_regiona)
            sendcef(str)
            return false
        end
		if cefstr:find('event.carNumbers.initializeCarNumber') and fast_nomera == true then
			cef_close();
			fast_nomera = false
		end
    end
end


function sendcef(str)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, 220)
    raknetBitStreamWriteInt8(bs, 18)
    raknetBitStreamWriteInt32(bs, #str)
    raknetBitStreamWriteString(bs, str)
    raknetBitStreamWriteInt32(bs, 0)
    raknetSendBitStream(bs)
    raknetDeleteBitStream(bs)
end


function cef_close()
	lua_thread.create(function()
		wait(50)
		local bytes = {
			{220, 0, 27, 64};
		}
		for a = 1, #bytes do
		  local bs = raknetNewBitStream();
		  for b = 1, #bytes[a] do
			raknetBitStreamWriteInt8(bs, bytes[a][b]);
		  end
		  raknetSendBitStreamEx(bs, 1, 7, 1)
		  raknetDeleteBitStream(bs)
		end
	end)
end