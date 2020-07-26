ESX = nil

local kurwarejka
local window0 = false
local window1 = false
local window2 = false
local window3 = false
local twojstarynajebany = false

Citizen.CreateThread(function()
 	while true do
		Citizen.Wait(5)
		if GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) == 0 then
			if (IsControlPressed(0, 56)) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'carcontrols_actions_actions') then
				carcontrolsmenu()
			end
		end
 	end
 end)

function carcontrolsmenu()
    ESX.UI.Menu.CloseAll()
	local ped = GetPlayerPed(-1)
	local veh = GetVehiclePedIsIn(ped, true)
	local lockStatus = GetVehicleDoorLockStatus(veh)
	local distanceveh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(veh), 1)
	if veh ~= 0 then
		if distanceveh < 10 then
			if lockStatus == 1 then --unlocked
				local elements = {}
				if DoesVehicleHaveDoor(veh, 0) then
					table.insert(elements, {label = 'Drzwi Przednie Lewe', value = 'door1'})
				end
				if DoesVehicleHaveDoor(veh, 1) then
					table.insert(elements, {label = 'Drzwi Przednie Prawe', value = 'door2'})
				end
				if DoesVehicleHaveDoor(veh, 2) then
					table.insert(elements, {label = 'Drzwi Tylnie Lewe', value = 'door3'})
				end
				if DoesVehicleHaveDoor(veh, 3) then
					table.insert(elements, {label = 'Drzwi Tylnie Prawe', value = 'door4'})
				end
				if DoesVehicleHaveDoor(veh, 4) then
					table.insert(elements, {label = 'Maska', value = 'hood'})
				end
				if DoesVehicleHaveDoor(veh, 5) then
					table.insert(elements, {label = 'Bagaznik', value = 'trunk'})
				end
				table.insert(elements, {label = 'Szyba Przednia Lewa', value = 'window1'})
				table.insert(elements, {label = 'Szyba Przednia Prawe', value = 'window2'})
				table.insert(elements, {label = 'Szyba Tylnia Lewe', value = 'window3'})
				table.insert(elements, {label = 'Szyba Tylnia Prawe', value = 'window4'})

				ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'carcontrols_actions',
				{
					title    = 'Samochod',
					align    = 'center',
					elements = elements

				}, function(data, menu)
					if data.current.value == 'door1' then
						openkurwadrzwikek(0)
					elseif data.current.value == 'door2' then
						openkurwadrzwikek(1)
					elseif data.current.value == 'door3' then
						openkurwadrzwikek(2)
					elseif data.current.value == 'door4' then
						openkurwadrzwikek(3)
					elseif data.current.value == 'hood' then
						openkurwadrzwikek(4)
					elseif data.current.value == 'trunk' then
						openkurwadrzwikek(5)
					elseif data.current.value == 'window1' then
						kurwaokna(0)
					elseif data.current.value == 'window2' then
						kurwaokna(1)
					elseif data.current.value == 'window3' then
						kurwaokna(2)
					elseif data.current.value == 'window4' then
						kurwaokna(3)
					end
				end, function(data, menu)
					menu.close()
				end)
			else -- locked
				ESX.ShowNotification('~r~Samochód jest zamknięty')
			end
		else
			ESX.ShowNotification('~r~Jestes za daleko pojazdu')
		end
	else
		ESX.ShowNotification('~r~Nie ma twojego samochodu w poblizu')
	end
end

function openkurwadrzwikek(door)
	local ped = GetPlayerPed(-1)
	local veh = GetVehiclePedIsUsing(ped)
	local vehLast = GetPlayersLastVehicle()
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
	if door ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if GetVehicleDoorAngleRatio(veh, door) > 0 then
                SetVehicleDoorShut(veh, door, false)
            else	
                SetVehicleDoorOpen(veh, door, false, false)
            end
        else
            if distanceToVeh < 10 then
                if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                	kurwaanimacja()
                    SetVehicleDoorShut(vehLast, door, false)
                else
                	kurwaanimacja()	
                    SetVehicleDoorOpen(vehLast, door, false, false)
                end
            else
            end
        end
    end
end

function kurwaanimacja()
    local ad = "anim@mp_player_intmenu@key_fob@"
    local anim = "fob_click"
    local ped = PlayerPedId()

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped )) and not IsPedInAnyVehicle(ped, true) then
        loadAnimDict( ad )
        if ( IsEntityPlayingAnim( ped, ad, anim, 1 ) ) then
            TaskPlayAnim( ped, ad, "exit", 8.0, 8.0, 1.0, 50, 0, 0, 0, 0 )
            ClearPedSecondaryTask(ped)
        else
            SetCurrentPedWeapon(ped, -1569615261,true)
            Citizen.Wait(1)
            TaskPlayAnim( ped, ad, anim, 8.0, 8.0, 850, 50, 0, 0, 0, 0 )
     	end
    end
end

function kurwaokna(window)
	local ped = GetPlayerPed(-1)
	local veh = GetVehiclePedIsIn(ped, true)
	local vehLast = GetPlayersLastVehicle()
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
	if IsPedInAnyVehicle(ped, false) then
		if window == 0 then
			if window0 then
				window0 = false
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window0, window)
			else
				window0 = true
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window0, window)
			end
		elseif window == 1 then
			if window1 then
				window1 = false
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window1, window)
			else
				window1 = true
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window1, window)
			end
		elseif window == 2 then
			if window2 then
				window2 = false
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window2, window)
			else
				window2 = true
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window2, window)
			end
		elseif window == 3 then
			if window3 then
				window3 = false
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window3, window)
			else
				window3 = true
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window3, window)
			end
		end
	else
		if distanceToVeh < 10 then
			if window == 0 then
				if window0 then
					window0 = false
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window0, window)
					kurwaanimacja()
				else
					window0 = true
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window0, window)
					kurwaanimacja()
				end
			elseif window == 1 then
				if window1 then
					window1 = false
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window1, window)
					kurwaanimacja()
				else
					window1 = true
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window1, window)
					kurwaanimacja()
				end
			elseif window == 2 then
				if window2 then
					window2 = false
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window2, window)
					kurwaanimacja()
				else
					window2 = true
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window2, window)
					kurwaanimacja()
				end
			elseif window == 3 then
				if window3 then
					window3 = false
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window3, window)
					kurwaanimacja()
				else
					window3 = true
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window3, window)
					kurwaanimacja()
				end
			end
		end
	end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent('kurwavehiclewidnow')
AddEventHandler( "kurwavehiclewidnow", function(playerID, windowsDown, window)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(playerID)), true)
    if window == 0 then
   	 	if windowsDown then
     	 	RollDownWindow(vehicle, window)
    	else
     		RollUpWindow(vehicle, window)
    	end
	elseif window == 1 then
   	 	if windowsDown then
     	 	RollDownWindow(vehicle, window)
    	else
     		RollUpWindow(vehicle, window)
    	end
	elseif window == 2 then
   	 	if windowsDown then
     	 	RollDownWindow(vehicle, window)
    	else
     		RollUpWindow(vehicle, window)
    	end
	elseif window == 3 then
   	 	if windowsDown then
     	 	RollDownWindow(vehicle, window)
    	else
     		RollUpWindow(vehicle, window)
    	end
	end
end)