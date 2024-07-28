require ('moonloader')
local inicfg = require 'inicfg'
math.randomseed(os.clock())
local mainini = inicfg.load({   
    launcher =
    {
        actor = true
    }
	}, "actor")
inicfg.save(mainini, 'actor.ini') 
if not doesFileExist('moonloader/config/actor.ini') then
	inicfg.save(mainini,'actor.ini')
end

local actor = mainini.launcher.actor



function main()
    while not isSampAvailable() do wait(222) end
    
    AFKMessage('Actor_AntiCrasher by Freym loaded. CMDS: /actor | Автор сидит тут: t.me/FREYM_FREYM',-1)
	sampRegisterChatCommand('actor',function()
        actor = not actor
        AFKMessage(tostring(actor))
        mainini.launcher.actor = actor
        inicfg.save(mainini, "actor.ini")
	end)
	sampRegisterChatCommand('unfr',function()
        local chars = getAllChars()
        for i = 1, #chars do
            local res, id = sampGetPlayerIdByCharHandle(chars[i])
            if res == false then
                freezeCharPosition(chars[i], false)
            end
        end
	end)
    while true do wait(111)
        if actor == true then
            local chars = getAllChars()
            for i = 1, #chars do
                local res, id = sampGetPlayerIdByCharHandle(chars[i])
                if res == false and isCharInAnyCar(PLAYER_PED) then
                    local x,y,z = getCharCoordinates(PLAYER_PED)
                    local a,b,c = getCharCoordinates(chars[i])
                    local veh_handle = storeCarCharIsInNoSave(PLAYER_PED)
                    local veh_free_seats = getCarFreeSeat(veh_handle)
                    if veh_free_seats ~= nil and getDistanceBetweenCoords3d(x,y,z, a,b,c) < 4 and not isCharInAnyCar(chars[i]) then
                        warpCharIntoCarAsPassenger(chars[i], veh_handle, veh_free_seats - 1 )
                    end
                end
            end
        end
    end
end

function getCarFreeSeat(car)
    if doesCharExist(getDriverOfCar(car)) then
      local maxPassengers = getMaximumNumberOfPassengers(car)
      for i = 0, maxPassengers do
        if isCarPassengerSeatFree(car, i) then
          return i + 1
        end
      end
      return nil 
    else
      return 0 
    end
end

AFKMessage = function(text) 
	sampAddChatMessage('[Freym-tech] {ffffff}'..text,0xFF4141) 
end