script_name = "[AntiRvanka]"
script_version = "3.1"
script_author = "Константин Горскин"

--~ =========================================================[LIBS]=========================================================
local res, inicfg		=		pcall(require, 'inicfg')				assert(res, "Lib INICFG not found")
local res, ev			= 		pcall(require, 'lib.samp.events')		assert(res, 'Lib SAMP Events not found')
--~ =======================================================[END LIBS]=======================================================

local directIni = 'AntiRvanka.ini'
local ini = inicfg.load(inicfg.load({
    settings = {
        status = false,
		sflogger = true,
		dialoglogger = true,
		printer = true,
        ONFOOT_SPEED_LIMIT = "0.7",
		INCAR_SPEED_LIMIT = "0.745",
		UNOC_SPEED_LIMIT = "0.614",
		ONFOOT_DIST_LIMIT = "5",
		INCAR_DIST_LIMIT = "7",
		UNOC_DIST_LIMIT = "160",
		MSG_CD = "2",
		PRINT_CD = "1",
		keyactive = "105",
    },
}, directIni))
inicfg.save(ini, directIni)

function save()
    inicfg.save(ini, directIni)
end

function main()
	repeat wait(100) until isSampAvailable()
	while sampGetGamestate() ~= 3 do return true end
	sampAddChatMessage(""..script_name.." {FFFFFF}Скрипт успешно загружен! Версия: {ff0077}"..script_version.." {FFFFFF}Автор: {ff0077}"..script_author, 0xff0077)
	sampAddChatMessage(""..script_name.." {FFFFFF}Ввведите: {ff0077}/arset {FFFFFF}чтобы открыть настройки скрипта", 0xff0077)
	sampAddChatMessage(""..script_name.." {FFFFFF}Ввведите: {ff0077}/arlogs {FFFFFF}чтобы открыть логи", 0xff0077)
	sampAddChatMessage(""..script_name.." {FFFFFF}Ввведите: {ff0077}/arsetkey {FFFFFF}чтобы изменить клавишу включения | выключения", 0xff0077)
	sampRegisterChatCommand('arset', settingsac)
	sampRegisterChatCommand('arlogs', logging)
	sampRegisterChatCommand('arsetkey', setkeyactive)
	while true do
	wait(0)
		if isKeyJustPressed(ini.settings.keyactive) and not sampIsCursorActive() then
			ini.settings.status = not ini.settings.status
			printStringNow(ini.settings.status and "AntiRvanka: ~g~ON" or "AntiRvanka: ~r~OFF", 2000)
			save()
		end
--~ =========================================================[SETTINGS]=============================================================
		local result, button, list, input = sampHasDialogRespond(11)
        if result then
            if button == 1 then
                if list == 0 then
                    ini.settings.status = not ini.settings.status
					save()
					settingsac()
				elseif list== 1 then
					ini.settings.sflogger = not ini.settings.sflogger
					save()
					settingsac()
				elseif list== 2 then
					ini.settings.dialoglogger = not ini.settings.dialoglogger
					save()
					settingsac()
				elseif list== 3 then
					ini.settings.printer = not ini.settings.printer
					save()
					settingsac()
				elseif list== 4 then
					parametrs()
				elseif list== 5 then
					logging()
				elseif list== 6 then
					filedel = getGameDirectory().."//moonloader//AntiRvankaLOG.txt"
					os.remove(filedel)
					settingsac()
                end
            end
        end
		local result, button, list, input = sampHasDialogRespond(80)
        if result then
            if button == 1 then
                if list == 0 then
                    setradius_onfoot()
                elseif list == 1 then
					setradius_incar()
				elseif list == 2 then
					setradius_unoccup()
				elseif list == 3 then
					setspeed_onfoot()
				elseif list == 4 then
					setspeed_incar()
				elseif list == 5 then
					setspeed_unoccup()
				elseif list == 6 then
					setcd()
				elseif list == 7 then
					setprintcd()
				elseif list == 8 then
					ini.settings.ONFOOT_SPEED_LIMIT = "0.7"
					ini.settings.INCAR_SPEED_LIMIT = "0.745"
					ini.settings.UNOC_SPEED_LIMIT = "0.613"
					ini.settings.ONFOOT_DIST_LIMIT = "5"
					ini.settings.INCAR_DIST_LIMIT = "7"
					ini.settings.UNOC_DIST_LIMIT = "160"
					ini.settings.MSG_CD = "2"
					ini.settings.PRINT_CD = "1"
					ini.settings.keyactive = "105"
					save()
					parametrs()
                end
			elseif button == 0 then
				settingsac()
            end
        end
		local result, button, list, input = sampHasDialogRespond(22)
        if result then
            if button == 1 then
				local id = tonumber(input)
				if type(id) ~= 'number' then
					beda()
				else
					ini.settings.ONFOOT_DIST_LIMIT = input
					save()
					parametrs()
				end
            end
			if button == 0 then
				parametrs()
			end
        end
		local result, button, list, input = sampHasDialogRespond(23)
        if result then
            if button == 1 then
				local id = tonumber(input)
				if type(id) ~= 'number' then
					beda()
				else
					ini.settings.INCAR_DIST_LIMIT = input
					save()
					parametrs()
				end
            end
			if button == 0 then
				parametrs()
			end
        end
		local result, button, list, input = sampHasDialogRespond(24)
        if result then
            if button == 1 then
				local id = tonumber(input)
				if type(id) ~= 'number' then
					beda()
				else
					ini.settings.UNOC_DIST_LIMIT = input
					save()
					parametrs()
				end
            end
			if button == 0 then
				parametrs()
			end
        end
		local result, button, list, input = sampHasDialogRespond(33)
        if result then
            if button == 1 then
				local id = tonumber(input)
				if type(id) ~= 'number' then
					beda()
				else
					ini.settings.ONFOOT_SPEED_LIMIT = input
					save()
					parametrs()
				end
            end
			if button == 0 then
                parametrs()
            end
        end
		local result, button, list, input = sampHasDialogRespond(34)
        if result then
            if button == 1 then
				local id = tonumber(input)
				if type(id) ~= 'number' then
					beda()
				else
					ini.settings.INCAR_SPEED_LIMIT = input
					save()
					parametrs()
				end
            end
			if button == 0 then
                parametrs()
            end
        end
		local result, button, list, input = sampHasDialogRespond(35)
        if result then
            if button == 1 then
				local id = tonumber(input)
				if type(id) ~= 'number' then
					beda()
				else
					ini.settings.UNOC_SPEED_LIMIT = input
					save()
					parametrs()
				end
            end
			if button == 0 then
                parametrs()
            end
        end
		local result, button, list, input = sampHasDialogRespond(44)
        if result then
            if button == 1 then
				local id = tonumber(input)
				if type(id) ~= 'number' then
					beda()
				else
					ini.settings.MSG_CD = input
					save()
					parametrs()
				end
            end
			if button == 0 then
                parametrs()
            end
        end
		local result, button, list, input = sampHasDialogRespond(55)
        if result then
            if button == 1 then
				local id = tonumber(input)
				if type(id) ~= 'number' then
					beda()
				else
					ini.settings.PRINT_CD = input
					save()
					parametrs()
				end
            end
			if button == 0 then
                parametrs()
            end
        end
		local result, button, list, input = sampHasDialogRespond(66)
        if result then
            if button == 1 then
                settingsac()
            end
        end
		local result, button, list, input = sampHasDialogRespond(77)
        if result then
            if button == 1 then
                parametrs()
            end
        end
--~ =========================================================[END SETTINGS]=========================================================
	end
end

function setkeyactive(arg)
	local id = tonumber(arg)
    if type(id) ~= 'number' then
        sampAddChatMessage(""..script_name.." {FFFFFF}Используйте: {ff0077}/arsetkey [id key]", 0xff0077)
    else
		ini.settings.keyactive = id
		save()
		sampAddChatMessage(""..script_name.." {FFFFFF}Вы установили клавишу: {ff0077}"..ini.settings.keyactive, 0xff0077)
    end
end

function settingsac()
sampShowDialog(11, 
"{ff0077}[AntiRvanka] {FFFFFF}Настройки антирванки",
"[0] Статус работы антирванки: \t"..(ini.settings.status and "{00FF00}[ON]" or "{FF0000}[OFF]").."\
[1] Логирование в консоль SF: \t"..(ini.settings.sflogger and "{00FF00}[ON]" or "{FF0000}[OFF]").."\
[2] Логирование в диалоговое окно: \t"..(ini.settings.dialoglogger and "{00FF00}[ON]" or "{FF0000}[OFF]").."\
[3] Отображение варнинга на экране: \t"..(ini.settings.printer and "{00FF00}[ON]" or "{FF0000}[OFF]").."\
[4] {FF0000}<< {FFFFFF}Изменить параметры антирванки {FF0000}>>\
[5] {FF0000}<< {FFFFFF}Посмотреть лог антирванки {FF0000}>>\
[6] {FF0000}<< {FFFFFF}Очистить лог антирванки {FF0000}>>\
", "{ff0077}»", "{ff0077}x", 4)
end

function parametrs()
sampShowDialog(80, 
"{ff0077}[AntiRvanka] {FFFFFF}Параметры антирванки",
"[0] Радиус действия ONFOOT: \t{ff0077}"..ini.settings.ONFOOT_DIST_LIMIT.."\
[1] Радиус действия INCAR: \t{ff0077}"..ini.settings.INCAR_DIST_LIMIT.."\
[2] Радиус действия UNOCCUPIED: \t{ff0077}"..ini.settings.UNOC_DIST_LIMIT.."\
[3] Скорость ONFOOT: \t{ff0077}"..ini.settings.ONFOOT_SPEED_LIMIT.."\
[4] Скорость INCAR: \t{ff0077}"..ini.settings.INCAR_SPEED_LIMIT.."\
[5] Скорость UNOCCUPIED: \t{ff0077}"..ini.settings.UNOC_SPEED_LIMIT.."\
[6] КД повторений варнингов: \t{ff0077}"..ini.settings.MSG_CD.."\
[7] КД отображения варнингов на экране: \t{ff0077}"..ini.settings.PRINT_CD.."\
[8] {FF0000}<< {FFFFFF}Сбросить все параметры на стандартные {FF0000}>>\
", "{ff0077}»", "{ff0077}x", 4)
end

function logging()
	file = io.open(getGameDirectory().."//moonloader//AntiRvankaLOG.txt", "a")
	file:close()
	filenameread = getGameDirectory().."//moonloader//AntiRvankaLOG.txt"
	local fileread
	fileread = io.open(filenameread, "r")
	read = fileread:read("*a")
	fileread:close()
	sampShowDialog(66, "{ff0077}[AntiRvanka] {FFFFFF}Система логирования", 
	"         Дата  |  Время\t\t\tИнформация о игроке\t\t\tТип рванки\n"..read,
	"{ff0077}Назад", nil, 5)
end

function setradius_onfoot()
sampShowDialog(22, "{ff0077}[AntiRvanka] {FFFFFF}Настройки ONFOOT",
"Настройки радиуса действия антирванки\
Введите число\
Текущий параметр: "..ini.settings.ONFOOT_DIST_LIMIT.."\
", "{ff0077}OK", "{ff0077}Назад", 1)
end

function setradius_incar()
sampShowDialog(23, "{ff0077}[AntiRvanka] {FFFFFF}Настройки INCAR",
"Настройки радиуса действия антирванки\
Введите число\
Текущий параметр: "..ini.settings.INCAR_DIST_LIMIT.."\
", "{ff0077}OK", "{ff0077}Назад", 1)
end

function setradius_unoccup()
sampShowDialog(24, "{ff0077}[AntiRvanka] {FFFFFF}Настройки UNOCCUP",
"Настройки радиуса действия антирванки\
Введите число\
Текущий параметр: "..ini.settings.UNOC_DIST_LIMIT.."\
", "{ff0077}OK", "{ff0077}Назад", 1)
end

function setspeed_onfoot()
sampShowDialog(33, "{ff0077}[AntiRvanka] {FFFFFF}Настройки",
"Настройки скорости\
Введите число\
Текущий параметр: "..ini.settings.ONFOOT_SPEED_LIMIT.."\
", "{ff0077}OK", "{ff0077}Назад", 1)
end

function setspeed_incar()
sampShowDialog(34, "{ff0077}[AntiRvanka] {FFFFFF}Настройки",
"Настройки скорости\
Введите число\
Текущий параметр: "..ini.settings.INCAR_SPEED_LIMIT.."\
", "{ff0077}OK", "{ff0077}Назад", 1)
end

function setspeed_unoccup()
sampShowDialog(35, "{ff0077}[AntiRvanka] {FFFFFF}Настройки",
"Настройки скорости\
Введите число\
Текущий параметр: "..ini.settings.UNOC_SPEED_LIMIT.."\
", "{ff0077}OK", "{ff0077}Назад", 1)
end

function setcd()
sampShowDialog(44, "{ff0077}[AntiRvanka] {FFFFFF}Настройки",
"Настройки времени повторений варнингов\
Введите число\
Текущий параметр: "..ini.settings.MSG_CD.."\
", "{ff0077}OK", "{ff0077}Назад", 1)
end

function setprintcd()
sampShowDialog(55, "{ff0077}[AntiRvanka] {FFFFFF}Настройки",
"Настройки времени отображения варнингов на экране\
Введите число\
Текущий параметр: "..ini.settings.PRINT_CD.."\
", "{ff0077}OK", "{ff0077}Назад", 1)
end


function beda()
sampShowDialog(77, "{ff0077}[AntiRvanka] {FFFFFF}Ошибка!",
"Указать можно только числа!\
", "{ff0077}OK", "", 0)
end

function getSpeedFromVector3D(vec)
    return math.sqrt(vec.x ^ 2 + vec.y ^ 2 + vec.z ^ 2)
end

function getDistanceFrom(vec)
    local x, y, z = getCharCoordinates(PLAYER_PED)
    return math.sqrt((vec.x - x) ^ 2 + (vec.y - y) ^ 2 + (vec.z - z) ^ 2)
end

local messages = {}

function warning(id, rtype)
    if messages[id] and os.clock() - messages[id] < tonumber(ini.settings.MSG_CD) then
        return
    end
    messages[id] = os.clock()
    pnick = sampIsPlayerConnected(id) and sampGetPlayerNickname(id)
	plvl = sampIsPlayerConnected(id) and sampGetPlayerScore(id)
	pping = sampIsPlayerConnected(id) and sampGetPlayerPing(id)
	if ini.settings.printer == true then
		sampAddChatMessage(string.format('{ff0077}[AntiRvanka] {FFFFFF}%s [ID: %d LVL: %d PING: %d] Возможно использует: %s rvanka', pnick, id, plvl, pping, rtype), -1)
		--printString(string.format('~r~[AntiRvanka]~w~%s [ID: ~g~%d ~w~LVL: ~g~%d ~w~PING: ~g~%d~w~] used: ~r~%s ~w~rvanka', pnick, id, plvl, pping, rtype), tonumber(ini.settings.PRINT_CD*1000))
	end
	if ini.settings.dialoglogger == true then
		file = io.open(getGameDirectory().."//moonloader//AntiRvankaLOG.txt", "a")
		file:write(string.format('{ff0077}['..os.date('%d.%m.%y | %H:%M:%S')..']\t\t\t%s [ID: %d LVL: %d PING: %d]\t\t\t%s рванка\n', pnick, id, plvl, pping, rtype))
		file:close()
	end
	if ini.settings.sflogger == true then
		sampfuncsLog(string.format('[AntiRvanka] ['..os.date('%d.%m.%y | %H:%M:%S')..'] %s [ID: %d LVL: %d PING: %d] used %s rvanka', pnick, id, plvl, pping, rtype))
	end
end

function ev.onPlayerSync(id, data)
    if ini.settings.status == true and getSpeedFromVector3D(data.moveSpeed) >= tonumber(ini.settings.ONFOOT_SPEED_LIMIT) and getDistanceFrom(data.position) <= tonumber(ini.settings.ONFOOT_DIST_LIMIT) then
		warning(id, "onfoot")
		return false
    end
end

function ev.onVehicleSync(id, veh, data)
    if ini.settings.status == true and getSpeedFromVector3D(data.moveSpeed) >= tonumber(ini.settings.INCAR_SPEED_LIMIT) and getDistanceFrom(data.position) <= tonumber(ini.settings.INCAR_DIST_LIMIT) then
	local resvh, vehHandle = sampGetCarHandleBySampVehicleId(veh)
		if not isCharInCar(PLAYER_PED, vehHandle) then
			warning(id, "incar")
			return false
		end
	end
end

function ev.onUnoccupiedSync(id, data)
	if ini.settings.status == true and getDistanceFrom(data.position) <= tonumber(ini.settings.UNOC_DIST_LIMIT) then
		if data.turnSpeed.x > 0.19 or data.turnSpeed.y > 0.19 or data.turnSpeed.z > 0.19 then
			warning(id, "unoccupied -> Volent Project")
			return false
		end
	end
    if ini.settings.status == true and getDistanceFrom(data.position) <= tonumber(ini.settings.UNOC_DIST_LIMIT) then
		if getSpeedFromVector3D(data.moveSpeed) >= tonumber(ini.settings.UNOC_SPEED_LIMIT) then
			warning(id, "unoccupied")
			return false
		end
	end
end