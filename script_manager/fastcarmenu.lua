function main()
    while not isSampAvailable() do wait(200) end
	AFKMessage('FastCarMenu by Freym loaded CMDS: /pcars | Автор сидит тут: t.me/FREYM_FREYM' ,-1)
	sampRegisterChatCommand('pcars', function()
		sampSendChat('/phone')
		sendcef('launchedApp|29')
		sampSendChat('/phone')
	end)
	wait(-1)
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

AFKMessage = function(text) 
	sampAddChatMessage('[Freym-tech] {ffffff}'..tostring(text),0xFF4141) 
end