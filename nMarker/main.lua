local function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local function DrawText3DMarker(x,y,z)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z + 5)
    
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString("V")
        DrawText(_x,_y)
    end
end

local function round(num, idp)
	if idp and idp>0 then
		local mult = 10^idp
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

--> No need native to check the distance with this :
local square = math.sqrt
local function getDistance(a, b) 
    local x, y, z = a.x-b.x, a.y-b.y, a.z-b.z
    return square(x*x+y*y+z*z)
end

Citizen.CreateThread(function()
    while true do
        if not IsRadarEnabled() then --> With this new condition it will show you your marker only if the mini-map is disabled.
            local waypoint = GetFirstBlipInfoId(8)
            if DoesBlipExist(waypoint) then
                local myPos = GetEntityCoords(GetPlayerPed(-1))
                local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypoint, Citizen.ResultAsVector())
                local distance = getDistance(myPos, coord)
                
                if distance > 999 then
                    roundOverKm = round(distance)  * math.pow(10, -3) --> Thanks to RAMEX_DELTA_GTA for his help.
                    DrawText3DMarker(coord.x, coord.y, myPos.z + 10)
                    DrawText3DTest(coord.x, coord.y, myPos.z + 2, roundOverKm.. " kilomètres")
                elseif distance > 0.1 and distance <= 999 then
                    DrawText3DMarker(coord.x, coord.y, myPos.z)
                    DrawText3DTest(coord.x, coord.y, myPos.z, round(distance).. " m")
                end
            end
        end
        Citizen.Wait(0)
    end
end)