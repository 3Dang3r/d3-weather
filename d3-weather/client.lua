local menuOpen = false

local function toggleMenu()
    menuOpen = not menuOpen
    SetNuiFocus(menuOpen, menuOpen)
    SendNUIMessage({ action = menuOpen and "show" or "hide" })
end

RegisterCommand("weatherr", function()
    toggleMenu()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menuOpen then
            if IsControlJustReleased(0, 25) then
                menuOpen = false
                SetNuiFocus(false, false)
                SendNUIMessage({ action = "hide" })
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menuOpen then
            if IsControlJustReleased(0, 322) then 
                menuOpen = false
                SetNuiFocus(false, false)
                SendNUIMessage({ action = "hide" })
            end
        end
    end
end)


RegisterNUICallback('setTime', function(data, cb)
    local hour = tonumber(data.hour)
    if hour then
        TriggerServerEvent("weatherMenu:setTime", hour)
    end
    cb('ok')
end)

RegisterNUICallback('setWeather', function(data, cb)
    local weather = data.weather
    if weather then
        TriggerServerEvent("weatherMenu:setWeather", weather)
    end
    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
    menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
    cb('ok')
end)


RegisterNetEvent("weatherMenu:syncWeather")
AddEventHandler("weatherMenu:syncWeather", function(weather)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypePersist(weather)
    SetWeatherTypeOvertimePersist(weather, 15.0)
end)

RegisterNetEvent("weatherMenu:syncTime")
AddEventHandler("weatherMenu:syncTime", function(hour)
    NetworkOverrideClockTime(hour, 0, 0)
end)
