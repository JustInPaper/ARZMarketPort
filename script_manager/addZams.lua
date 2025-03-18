addEventHandler('onReceivePacket', function (id, bs)
    if id == 220 then
        raknetBitStreamIgnoreBits(bs, 8)
        if (raknetBitStreamReadInt8(bs) == 17) then
            raknetBitStreamIgnoreBits(bs, 32)
            local length = raknetBitStreamReadInt16(bs)
            local encoded = raknetBitStreamReadInt8(bs)
            local str = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)
            if str ~= nil then
                if str:find('event.business.info.initializeMenuTabs') and str:find('Управление бизнесом') and str:find('Найти бизнес в GPS') then
                    local thisString = str:gsub('{"id":1,"title":"Найти бизнес в GPS"},', '{"id":1,"title":"Найти бизнес в GPS"},{"id":9,"title":"[+] Изменить заместителей бизнеса"},')
                    if thisString ~= nil then
                        getCEF(thisString)
                        return false
                    end
                end
            end
        end
    end
end)

function main()
    while not isSampAvailable() do wait(222) end
    AFKMessage('addZams by Freym loaded.',-1)
    while true do wait(-1) end
end

getCEF = function(str)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, 17)
    raknetBitStreamWriteInt32(bs, 0)
    raknetBitStreamWriteInt16(bs, #str)
    raknetBitStreamWriteInt8(bs, is_encoded and 1 or 0)
    if is_encoded then
        raknetBitStreamEncodeString(bs, str)
    else
        raknetBitStreamWriteString(bs, str)
    end
    raknetEmulPacketReceiveBitStream(220, bs)
    raknetDeleteBitStream(bs)
end

AFKMessage = function(text) 
	sampAddChatMessage('[Freym-tech] {ffffff}'..text,0xFF4141) 
end