function main()
    repeat wait(0) until isSampAvailable()
    sampAddChatMessage("DisableVideo | Loaded.", -1)
end


function onReceivePacket(id, bs)
	if id == 220 then
        local text, packets = bitStreamStructure(bs)
		if text:find('http') and not text:find('DonateJson') then
            return false
		end
    end
end

function bitStreamStructure(bs)
    local text, array = '', {}
    for i = 1, raknetBitStreamGetNumberOfBytesUsed(bs) do
        local byte = raknetBitStreamReadInt8(bs)
        if byte >= 32 and byte <= 255 then text = text .. string.char(byte) end
        table.insert(array, byte)
    end
    raknetBitStreamResetReadPointer(bs)
    return text, array
end