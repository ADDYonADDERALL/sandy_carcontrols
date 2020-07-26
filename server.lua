ESX = nil

RegisterServerEvent( "sandycarmenu:SetVehicleWindow" )
AddEventHandler( "sandycarmenu:SetVehicleWindow", function(windowsDown,window)
  TriggerClientEvent( "kurwavehiclewidnow", -1, source, windowsDown, window)
end)