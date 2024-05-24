local QBCore = exports['qb-core']:GetCoreObject()

-- Load the configuration
Config = Config or {}
Config = setmetatable(Config, { __index = function(_, k) return rawget(_G, k) end })

local nightVisionEnabled = false
local currentVisionItem = nil

-- Function to apply night vision effect
local function applyNightVision()
    SetNightvision(true)
    SetTimecycleModifier("NG_scope_zoom")
    SetTimecycleModifierStrength(1.0) -- Adjust strength of the effect (0.0 to 1.0)
end

-- Function to apply thermal vision effect
local function applyThermalVision()
    SetTimecycleModifier(Config.NightVisionItems["advanced_night_vision_camera"].filter)
    SetTimecycleModifierStrength(0.9) -- Adjust strength of the effect (0.0 to 1.0)
end

-- Function to toggle night vision
local function toggleVision(itemName)
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local hasItem = QBCore.Functions.HasItem(itemName)
        if hasItem then
            local mode = Config.NightVisionItems[itemName].mode
            local filter = Config.NightVisionItems[itemName].filter
            if nightVisionEnabled and currentVisionItem == itemName then
                SetNightvision(false)
                ClearTimecycleModifier()
                nightVisionEnabled = false
                QBCore.Functions.Notify(Config.NightVisionItems[itemName].messageOff)
                currentVisionItem = nil
            else
                if nightVisionEnabled then
                    SetNightvision(false)
                    ClearTimecycleModifier()
                    QBCore.Functions.Notify(Config.NightVisionItems[currentVisionItem].messageOff)
                end
                if mode == "thermal" then
                    applyThermalVision()
                else
                    applyNightVision()
                end
                nightVisionEnabled = true
                QBCore.Functions.Notify(Config.NightVisionItems[itemName].messageOn)
                currentVisionItem = itemName
            end
        else
            QBCore.Functions.Notify(Config.Messages.NoNightvision)
        end
    else
        QBCore.Functions.Notify(Config.Messages.NotInVehicle)
    end
end



-- Keybind for toggling night vision
RegisterKeyMapping('toggleNightVision', 'Toggle Night Vision', 'keyboard', Config.ToggleKey)
RegisterCommand('toggleNightVision', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        for itemName, _ in pairs(Config.NightVisionItems) do
            if QBCore.Functions.HasItem(itemName) then
                toggleVision(itemName)
                return
            end
        end
        QBCore.Functions.Notify(Config.Messages.NoNightvision)
    else
        QBCore.Functions.Notify(Config.Messages.NotInVehicle)
    end
end, false)

-- Ensure vision is turned off when player exits the vehicle or loses the item
CreateThread(function()
    while true do
        Wait(500)
        local playerPed = PlayerPedId()
        if not IsPedInAnyVehicle(playerPed, false) then
            if nightVisionEnabled then
                SetNightvision(false)
                if Config.NightVisionItems[currentVisionItem].filter then
                    ClearTimecycleModifier()
                end
                nightVisionEnabled = false
                currentVisionItem = nil
            end
        else
            if currentVisionItem and not QBCore.Functions.HasItem(currentVisionItem) then
                SetNightvision(false)
                if Config.NightVisionItems[currentVisionItem].filter then
                    ClearTimecycleModifier()
                end
                QBCore.Functions.Notify(Config.NightVisionItems[currentVisionItem].messageOff)
                nightVisionEnabled = false
                currentVisionItem = nil
            end
        end
    end
end)


