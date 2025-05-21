ESX = exports["es_extended"]:getSharedObject()
local cooldowns = {}
local props = {}
local isHarvesting = false
local harvestTime = 0
local startTime = 0

-- Spawn props at start
CreateThread(function()
    for i, data in pairs(Config.Locations) do
        local obj = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z - 1.0, false, false, false)
        SetEntityAsMissionEntity(obj, true, true)
        FreezeEntityPosition(obj, true)
        props[i] = obj
    end
end)

-- Main interaction loop
CreateThread(function()
    while true do
        local sleep = 1500
        local playerCoords = GetEntityCoords(PlayerPedId())

        for i, data in pairs(Config.Locations) do
            local dist = #(playerCoords - data.coords)

            if dist < 2.5 then
                if not cooldowns[i] then
                    sleep = 0
                    ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to harvest")

                    if IsControlJustReleased(0, 38) and not isHarvesting then
                        cooldowns[i] = true
                        TriggerEvent("wizard_divingharvest:anim", i, data)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

-- Play animation, show progress bar, remove prop AFTER
RegisterNetEvent("wizard_divingharvest:anim", function(index, data)
    local ped = PlayerPedId()
    isHarvesting = true
    harvestTime = data.animTime
    startTime = GetGameTimer()

    -- Play animation
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)

    -- Wait duration while showing bar
    Wait(data.animTime * 1000)
    ClearPedTasks(ped)
    isHarvesting = false

    -- Remove prop
    if props[index] then
        DeleteEntity(props[index])
        props[index] = nil
    end

    -- Give reward
    TriggerServerEvent("wizard_divingharvest:giveItems", index)

    -- Respawn after cooldown
    SetTimeout(data.returnTime * 1000, function()
        cooldowns[index] = nil
        local obj = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z - 1.0, false, false, false)
        SetEntityAsMissionEntity(obj, true, true)
        FreezeEntityPosition(obj, true)
        props[index] = obj
    end)
end)

-- Draw UI progress bar (extra small version)
CreateThread(function()
    while true do
        Wait(0)
        if isHarvesting then
            local elapsed = (GetGameTimer() - startTime) / 1000
            local remaining = math.ceil(harvestTime - elapsed)
            local progress = elapsed / harvestTime

            -- Extra small dimensions
            local barWidth = 0.10
            local barHeight = 0.01
            local borderSize = 0.005

            local centerX = 0.5
            local centerY = 0.92

            -- White border
            DrawRect(centerX, centerY, barWidth + borderSize, barHeight + borderSize, 255, 255, 255, 200)

            -- Background black bar
            DrawRect(centerX, centerY, barWidth, barHeight, 0, 0, 0, 220)

            -- Green progress
            DrawRect(centerX - (barWidth / 2) + (progress * barWidth / 2), centerY, progress * barWidth, barHeight, 50, 205, 50, 255)

            -- Text removed
        end
    end
end)

-- Blip for diving zone
CreateThread(function()
    local zoneCenter = vector3(3370.0320, 447.7310, -65.2014)
    local radius = 100.0

    local blip = AddBlipForCoord(zoneCenter)
    SetBlipSprite(blip, 68)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Diving Zone")
    EndTextCommandSetBlipName(blip)

    local radiusBlip = AddBlipForRadius(zoneCenter, radius)
    SetBlipColour(radiusBlip, 3)
    SetBlipAlpha(radiusBlip, 128)
end)
