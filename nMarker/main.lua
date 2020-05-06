function DrawText3DTest(x,y,z, text)
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


function DrawText3DMarker(x,y,z)
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

function round(num, idp)
	if idp and idp>0 then
		local mult = 10^idp
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

Citizen.CreateThread(function()
    while true do
		local waypoint = GetFirstBlipInfoId(8)
		if DoesBlipExist(waypoint) then
			local myPed = GetPlayerPed(-1)
			local myPos = GetEntityCoords(myPed)
			local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypoint, Citizen.ResultAsVector())
            local distance = GetDistanceBetweenCoords(myPos.x, myPos.y, myPos.z, coord.x, coord.y, coord.z, false)
            
            if distance > 999 then
                roundOverKm = round(distance)  * math.pow(10, -3) --> Thanks to RAMEX_DELTA_GTA for his help.
                DrawText3DMarker(coord.x, coord.y, myPos.z + 10)
                DrawText3DTest(coord.x, coord.y, myPos.z + 2, roundOverKm.. " kilomètres")
            elseif distance > 0.1 and distance <= 999 then
                DrawText3DMarker(coord.x, coord.y, myPos.z)
                DrawText3DTest(coord.x, coord.y, myPos.z, round(distance).. " m")
            end
		end
        Citizen.Wait(0)
    end
end)


