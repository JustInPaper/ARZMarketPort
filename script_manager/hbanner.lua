require ('moonloader')
local inicfg = require 'inicfg'
math.randomseed(os.clock())
local mainini = inicfg.load({   
    launcher =
    {
        banner = true
    }
	}, "banner")
inicfg.save(mainini, 'banner1.ini') 
if not doesFileExist('moonloader/config/banner1.ini') then
	inicfg.save(mainini,'banner1.ini')
end

local banner = mainini.launcher.banner

function onReceivePacket(id, bitStream)
    if banner == true then
        if (id == 220) then
            raknetBitStreamIgnoreBits(bitStream, 8)
            if (raknetBitStreamReadInt8(bitStream) == 17) then
                raknetBitStreamIgnoreBits(bitStream, 32)
                cefstr = raknetBitStreamReadString(bitStream, raknetBitStreamReadInt32(bitStream))
                if cefstr ~= nil then
                    if cefstr:find('RewardBanner') and cefstr:find('event.setActiveView') then
                        sendCEF('rewardBanner.close')
                        -- return false
                    end
                end
            end
        end
    end
end

function main()
    while not isSampAvailable() do wait(222) end
    AFKMessage('AutoCloseBanner by Freym loaded. CMDS: /banners | Автор сидит тут: t.me/FREYM_FREYM',-1)
	sampRegisterChatCommand('banners',function()
        banner = not banner
        AFKMessage(tostring(banner))
        mainini.launcher.banner = banner
        inicfg.save(mainini, "banner1.ini")
	end)
    while true do wait(-1) end
end

sendCEF = function(str)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, 220)
    raknetBitStreamWriteInt8(bs, 18)
    raknetBitStreamWriteInt16(bs, #str)
    raknetBitStreamWriteString(bs, str)
    raknetBitStreamWriteInt32(bs, 0)
    raknetSendBitStream(bs)
    raknetDeleteBitStream(bs)
end

AFKMessage = function(text) 
	sampAddChatMessage('[Freym-tech] {ffffff}'..text,0xFF4141) 
end