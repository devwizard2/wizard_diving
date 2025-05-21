ESX = nil
ESX = exports["es_extended"]:getSharedObject()

RegisterCommand('divegear', function(source, args, user)
    TriggerClientEvent("wizard_diving:client:UseGear", source, false)
end, true)

ESX.RegisterUsableItem('diving_gear', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('diving_gear', 1)

    TriggerClientEvent("wizard_diving:client:UseGear", source, true)
end)

RegisterServerEvent('wizard_diving:server:RemoveItem')
AddEventHandler('wizard_diving:server:RemoveItem', function(item, amount)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    Player.removeInventoryItem(item, amount)
end)
