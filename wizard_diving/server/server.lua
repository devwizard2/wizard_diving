ESX = nil
ESX = exports["es_extended"]:getSharedObject()



RegisterServerEvent('wizard_diving:server:RemoveGear')
AddEventHandler('wizard_diving:server:RemoveGear', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    Player.removeInventoryItem('diving_gear', 1)
end)

RegisterServerEvent('wizard_diving:server:GiveBackGear')
AddEventHandler('wizard_diving:server:GiveBackGear', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    
    Player.addInventoryItem('diving_gear', 1)
end)
