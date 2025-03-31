addEventHandler('onReceivePacket', function (id, bitStream)
	if id == 34 then
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, 131)
        raknetBitStreamWriteInt8(bs, 0)
        raknetEmulPacketReceiveBitStream(220, bs)
        raknetDeleteBitStream(bs)
    end
end)
--[[Thx rice for this packet]]