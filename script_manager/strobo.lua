require "lib.moonloader"
local sampev = require("samp.events")
local inicfg = require 'inicfg'
local mainini = inicfg.load({   
    launcher =
    {
        strobo_a = true, 
        strobo_b = false,
		speed = 200,
    }
	}, "newstrobo")
inicfg.save(mainini, 'newstrobo.ini') 
if not doesFileExist('moonloader/config/newstrobo.ini') then
	inicfg.save(mainini,'newstrobo.ini')
end

local strobo_a = mainini.launcher.strobo_a 
local strobo_b = mainini.launcher.strobo_b
local speed = mainini.launcher.speed

function main()
	if not isCleoLoaded() or not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end
	AFKMessage('New strobo by Freym loaded CMDS: /strobo | Автор сидит тут: t.me/FREYM_FREYM' ,-1)
	sampRegisterChatCommand("strobo", function()
		create_dialog(90000, 5, 'Стробо Меню', "Выбрать {469AE5}>", 'Отмена {DC0B17}X', '{ffffff}Функция:\t{ffffff}Статус:\nНовые стробоскопы (Дальний свет)	'..(strobo_a and '{469AE5}Включено' or '{DC0B17}Выключено')..'\nСтробоскопы с помощью смены фар	'..(strobo_b and '{469AE5}Включено' or '{DC0B17}Выключено')..'\nСкорость стробоскопов	'..tostring(speed)..'\n'..(isCarSirenOn(car) and '{DC0B17}Выключить стробоскопы' or '{469AE5}Включить стробоскопы'))
	end)
	lua_thread.create(strobe)
	while true do
		wait(-1)
	end
end

function save_all()
    mainini.launcher.strobo_a = strobo_a
    mainini.launcher.strobo_b = strobo_b
    mainini.launcher.speed = speed
    inicfg.save(mainini, "newstrobo.ini")
end

function sampev.onSendDialogResponse(dialogid, button, list, text)
	if dialogid == 024464 and button == 1 then
		if list == 0 then
			strobo_a = not strobo_a
		elseif list == 1 then
			strobo_b = not strobo_b
		elseif list == 2 then
			create_dialog(100000, 1, 'Стробо Меню', "Выбрать {469AE5}>", 'Отмена {DC0B17}X', 'Укажите время задержки в миллисекундах:')
			return false
		elseif list == 3 then
			if isCharInAnyCar(PLAYER_PED) then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				local driverPed = getDriverOfCar(car)
				
				if PLAYER_PED == driverPed then
					local state = not isCarSirenOn(car)
					switchCarSiren(car, state)
					if state == false then
						local ptr = getCarPointer(car) + 1440
						stroboscopes(7086336, ptr, 2, 0, 1, 0, 1)
					end
				end
			end
		end
		local car = false
		if isCharInAnyCar(PLAYER_PED) then
			car = storeCarCharIsInNoSave(PLAYER_PED)
		end
		save_all();
		create_dialog(90000, 5, 'Стробо Меню', "Выбрать {469AE5}>", 'Отмена {DC0B17}X', '{ffffff}Функция:\t{ffffff}Статус:\nНовые стробоскопы (Дальний свет)	'..(strobo_a and '{469AE5}Включено' or '{DC0B17}Выключено')..'\nСтробоскопы с помощью смены фар	'..(strobo_b and '{469AE5}Включено' or '{DC0B17}Выключено')..'\nСкорость стробоскопов	'..tostring(speed)..'\n'..(isCarSirenOn(car) and '{DC0B17}Выключить стробоскопы' or '{469AE5}Включить стробоскопы'))
		return false
	elseif dialogid == 034464 and button == 1 and text:find('(%d+)') then
		speed = tonumber(text:match('(%d+)'))
		create_dialog(90000, 5, 'Стробо Меню', "Выбрать {469AE5}>", 'Отмена {DC0B17}X', '{ffffff}Функция:\t{ffffff}Статус:\nНовые стробоскопы (Дальний свет)	'..(strobo_a and '{469AE5}Включено' or '{DC0B17}Выключено')..'\nСтробоскопы с помощью смены фар	'..(strobo_b and '{469AE5}Включено' or '{DC0B17}Выключено')..'\nСкорость стробоскопов	'..tostring(speed)..'\n'..(isCarSirenOn(car) and '{DC0B17}Выключить стробоскопы' or '{469AE5}Включить стробоскопы'))
		save_all();
		return false
	end
end

function stroboscopes(adress, ptr, _1, _2, _3, _4, end_strobo)
	if end_strobo ~= nil then
		forceCarLights(storeCarCharIsInNoSave(PLAYER_PED), 0)
		callMethod(7086336, ptr, 2, 0, 1, 3)
		callMethod(7086336, ptr, 2, 0, 0, 0)
		callMethod(7086336, ptr, 2, 0, 1, 0)
		markCarAsNoLongerNeeded(storeCarCharIsInNoSave(PLAYER_PED)) 
		return
	end

	if not isCharInAnyCar(PLAYER_PED) or strobo_b == false then return end

	callMethod(adress, ptr, _1, _2, _3, _4)
end

function strobo_packet()
	if strobo_a == false then return end
	local bytes = {
		{220, 0, 2, 0, 0},
	} 
	for a = 1, #bytes do
		local bs = raknetNewBitStream();
		for b = 1, #bytes[a] do
			raknetBitStreamWriteInt8(bs, bytes[a][b]);
		end
		raknetSendBitStreamEx(bs, 1, 7, 1)
		raknetDeleteBitStream(bs)
	end
end

function create_dialog(dialogId, dialogStyle, dialogTitle, button1, button2, text)
	local ind = ''..os.clock()
    lua_thread.create(function(ind)
        wait(25)
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt16(bs, dialogId)
        raknetBitStreamWriteInt8(bs, dialogStyle)
        raknetBitStreamWriteInt8(bs, tonumber(dialogTitle:len()))
        raknetBitStreamWriteString(bs, tostring(dialogTitle))
        raknetBitStreamWriteInt8(bs, tonumber(button1:len()))
        raknetBitStreamWriteString(bs, tostring(button1))
        raknetBitStreamWriteInt8(bs, tonumber(button2:len()))
        raknetBitStreamWriteString(bs, tostring(button2))
        raknetBitStreamEncodeString(bs, tostring(text))
        raknetEmulRpcReceiveBitStream(61, bs)
        raknetDeleteBitStream(bs)
    end, ind)
end

function strobe()
	while true do
		wait(0)
		
		if isCharInAnyCar(PLAYER_PED) then
		
			local car = storeCarCharIsInNoSave(PLAYER_PED)
			local driverPed = getDriverOfCar(car)
			
			if isCarSirenOn(car) and PLAYER_PED == driverPed then
			
				local ptr = getCarPointer(car) + 1440

				while isCarSirenOn(car) do
					strobo_packet()
					stroboscopes(7086336, ptr, 2, 0, 1, 0)
					stroboscopes(7086336, ptr, 2, 0, 0, 1)
					wait(speed)
					stroboscopes(7086336, ptr, 2, 0, 1, 1)
					stroboscopes(7086336, ptr, 2, 0, 0, 0)
					wait(speed)
					if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end
				end
			end
		end
	end
end

AFKMessage = function(text) 
	sampAddChatMessage('[Freym-tech] {ffffff}'..text,0xFF4141) 
end