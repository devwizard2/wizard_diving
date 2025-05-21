local ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent("wizard_divingharvest:giveItems")
AddEventHandler("wizard_divingharvest:giveItems", function(index)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local data = Config.Locations[index]
    if not data then return end

    for _, item in ipairs(data.items) do
        if math.random(1, 100) <= item.chance then
            local amount = math.random(1, 7)
            exports.ox_inventory:AddItem(xPlayer.source, item.name, amount)
        end
    end
end)
