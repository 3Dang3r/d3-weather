RegisterNetEvent("weatherMenu:setWeather")
AddEventHandler("weatherMenu:setWeather", function(weather)
    TriggerClientEvent("weatherMenu:syncWeather", -1, weather)
end)

RegisterNetEvent("weatherMenu:setTime")
AddEventHandler("weatherMenu:setTime", function(hour)
    TriggerClientEvent("weatherMenu:syncTime", -1, hour)
end)
