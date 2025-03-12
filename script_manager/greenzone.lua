local sampev = require("samp.events")
local oldtime = os.clock() - 1
local inicfg = require 'inicfg'
local mainini = inicfg.load({   
    launcher =
    {
        posX = 25, 
        posY = 433,
        gzinfobar = true,
        state = ''
    }
	}, "gzhelper")
inicfg.save(mainini, 'gzhelper.ini') 
if not doesFileExist('moonloader/config/gzhelper.ini') then
	inicfg.save(mainini,'gzhelper.ini')
end


function main()
	if not isSampLoaded() then return end
 		while not isSampAvailable() do wait(100) end
		wait(255)
        posX = mainini.launcher.posX; posY = mainini.launcher.posY; gzinfobar = mainini.launcher.gzinfobar; gz_informer = mainini.launcher.state
        AFKMessage('Green Zone Helper By Freym loaded. CMDS: /menuedit | /gzbar' ,-1)
        sampRegisterChatCommand("menuedit", function()
            menuedit = not menuedit
            if menuedit == false then
                local bs = raknetNewBitStream()
                raknetBitStreamWriteBool(bs, false)
                raknetEmulRpcReceiveBitStream(83, bs)
                raknetBitStreamWriteInt32(bs, 0) 
                raknetDeleteBitStream(bs)
                save_all()
            else
                local bs = raknetNewBitStream()
                raknetBitStreamWriteBool(bs, true)
                raknetEmulRpcReceiveBitStream(83, bs)
                raknetBitStreamWriteInt32(bs, 0) 
                raknetDeleteBitStream(bs)
            end
        end) 
        sampRegisterChatCommand("gzbar", function()
            gzinfobar = not gzinfobar
            if gzinfobar == false then
                sampTextdrawDelete(1998)
                sampTextdrawDelete(1997)
                save_all()
            end
        end) 
        if getGameGlobal(707) == 22 then
            applySampfuncsPatch()
        end
    while true do wait(0)
        if (os.clock() - oldtime) > 1.5 and sampIsLocalPlayerSpawned() == true and not sampIsDialogActive() and not isPauseMenuActive() and not sampIsChatInputActive() and gzinfobar == true then 
            oldtime = os.clock()
            sampSendChat('/gzinfo')
        end
        if menuedit == true then
            posX, posY = convertWindowScreenCoordsToGameScreenCoords(getCursorPos())
            printString('~G~/menuedit to save settings', 10)
        end
        if gzinfobar == true then
            sampTextdrawCreate(1998, 'GREENZONE:', posX, posY )
            sampTextdrawSetLetterSizeAndColor(1998, 0.3, 1.0, 0xFF87CEFA)
            sampTextdrawSetOutlineColor(1998, 0.5, 0xFF000000)
            sampTextdrawSetAlign(1998, 1)
            sampTextdrawSetStyle(1998, 1)
            sampTextdrawCreate(1997, tostring(gz_informer), posX + 62, posY)
            sampTextdrawSetLetterSizeAndColor(1997, 0.3, 1.0, 0xFF87CEFA)
            sampTextdrawSetOutlineColor(1997, 0.5, 0xFF000000)
            sampTextdrawSetAlign(1997, 1)
            sampTextdrawSetStyle(1997, 1)
        end
    end
end

function sampev.onSendClickTextDraw(id) -- отправка текстдрава
    if id == 65535 and menuedit == true then
        menuedit = false
        local bs = raknetNewBitStream()
        raknetBitStreamWriteBool(bs, false)
        raknetEmulRpcReceiveBitStream(83, bs)
        raknetBitStreamWriteInt32(bs, 0) 
        raknetDeleteBitStream(bs)
        save_all()
        return false
    end
end

function applySampfuncsPatch()
    local memory = memory or require 'memory'
    local module = getModuleHandle("SAMPFUNCS.asi")
    if module ~= 0 and memory.compare(module + 0xBABD, memory.strptr('\x8B\x43\x04\x8B\x5C\x24\x20\x8B\x48\x34\x83\xE1'), 12) then
        memory.setuint16(module + 0x83349, 0x01ac, true)
        memory.setuint16(module + 0x8343c, 0x01b0, true)
        memory.setuint16(module + 0x866dd, 0x00f4, true)
        memory.setuint16(module + 0x866e9, 0x0306, true)
        memory.setuint8(module + 0x8e754, 0x40, true)
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
    mainini.launcher.gzinfobar = gzinfobar
    mainini.launcher.state = (gz_informer == nil and 'None' or gz_informer)
    inicfg.save(mainini, "gzhelper.ini")
end

addEventHandler('onReceivePacket', function (id, bs)
	if id == 220 then
        local PacketID = raknetBitStreamReadInt8(bs)
        local isGreenZonePacket = raknetBitStreamReadInt8(bs)
        local state = raknetBitStreamReadInt8(bs)
        if isGreenZonePacket == 110 and (state == 1 or state == 0) then
            gz_informer = (state == 1 and '~G~YES' or '~R~NO')
        end
    end
    if id == 34 then
        gz_informer = 'None'
    end
end)

function sampev.onServerMessage(color, text)
	if gzinfobar == true and text:find('E_CURRENT_AREA_TYPE_INDEX') and color == -16776961 then
		return false
	end
	if gzinfobar == true and text:find('E_AREA_TYPE_ID') and color == -16776961 then
		return false
	end
    if gzinfobar == true and text:find('current gz index') and color == -16776961 then
        if text:find('65535') then
            gz_informer = '~R~NO'
        else
            gz_informer = '~G~YES'
        end
        return false
    end
    if text:find('Не флуди') and color == -10270721 then
        return false
    end
end

AFKMessage = function(text) 
	sampAddChatMessage('[Freym-tech] {ffffff}'..text,0xFF4141) 
end
