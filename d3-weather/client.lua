local menuOpen = false

local function toggleMenu()
    menuOpen = not menuOpen
    SetNuiFocus(menuOpen, menuOpen)
    SendNUIMessage({ action = menuOpen and "show" or "hide" })
end

RegisterCommand('weatherr', function()
    toggleMenu()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menuOpen then
            if IsControlJustReleased(0, 25) then -- Right mouse button
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
        NetworkOverrideClockTime(hour, 0, 0)
    end
    cb('ok')
end)

RegisterNUICallback('setWeather', function(data, cb)
    local weatherType = data.weather
    if weatherType then
        TriggerServerEvent('weatherMenu:setWeather', weatherType)
    end
    cb('ok')
end)

RegisterNetEvent('weatherMenu:applyWeather', function(weatherType)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeNow(weatherType)
    SetWeatherTypeNowPersist(weatherType)
    SetWeatherTypePersist(weatherType)
    SetWeatherTypeOvertimePersist(weatherType, 15.0)
end)

RegisterNUICallback('close', function(_, cb)
    menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
    cb('ok')
end)
